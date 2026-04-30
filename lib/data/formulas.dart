import 'dart:math';

/// Result class for formula calculations that can hold either a numeric result or an error
class FormulaResult {
  final double? value;
  final String? error;
  final bool isStringResult;
  final String? stringValue;

  FormulaResult.success(this.value, {this.isStringResult = false, this.stringValue})
      : error = null;
  FormulaResult.error(this.error)
      : value = null,
        isStringResult = false,
        stringValue = null;

  bool get isValid => error == null && value != null && !value!.isNaN && !value!.isInfinite;
  bool get hasError => error != null;
}

/// Validates input values for formula calculations
class InputValidator {
  static FormulaResult validate(double value, String fieldName, {
    double? min,
    double? max,
    bool allowNegative = true,
    bool allowZero = true,
    bool allowNaN = false,
  }) {
    if (!allowNaN && value.isNaN) {
      return FormulaResult.error('$fieldName: Invalid number (NaN)');
    }
    if (value.isInfinite) {
      return FormulaResult.error('$fieldName: Value too large');
    }
    if (!allowNegative && value < 0) {
      return FormulaResult.error('$fieldName: Must be non-negative');
    }
    if (!allowZero && value == 0) {
      return FormulaResult.error('$fieldName: Cannot be zero');
    }
    if (min != null && value < min) {
      return FormulaResult.error('$fieldName: Must be at least $min');
    }
    if (max != null && value > max) {
      return FormulaResult.error('$fieldName: Must be at most $max');
    }
    return FormulaResult.success(value);
  }
}

/// Safe mathematical operations with error handling
class MathOps {
  static const double _epsilon = 1e-10;
  static const double _maxValue = 1e308;
  static const double _minValue = 1e-308;

  static double safeDivide(double a, double b) {
    if (b.abs() < _epsilon) {
      return b >= 0 ? double.infinity : double.negativeInfinity;
    }
    double result = a / b;
    return _clamp(result);
  }

  static double safeSqrt(double value) {
    if (value < -_epsilon) {
      return double.nan;
    }
    if (value < 0) return 0; // Handle near-zero negative values
    return sqrt(value);
  }

  static double safeLog(double value) {
    if (value <= 0) return double.nan;
    return log(value);
  }

  static double safePow(double base, double exp) {
    if (base < 0 && exp != exp.floor()) {
      return double.nan; // Complex result for negative base with non-integer exponent
    }
    double result = pow(base, exp).toDouble();
    return _clamp(result);
  }

  static double _clamp(double value) {
    if (value.isNaN || value.isInfinite) return value;
    if (value.abs() > _maxValue) {
      return value > 0 ? double.infinity : double.negativeInfinity;
    }
    if (value.abs() < _minValue) return 0;
    return value;
  }

  static int factorial(int n) {
    if (n < 0) return 0;
    if (n <= 1) return 1;
    if (n > 170) return 0; // Prevent overflow
    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
      if (result == 0) break; // Overflow protection
    }
    return result;
  }

  static double safeFactorial(num n) {
    if (n < 0 || n != n.floor()) {
      return double.nan;
    }
    return factorial(n.toInt()).toDouble();
  }
}

/// Metadata about a formula variable
class FormulaVariable {
  final String symbol;
  final String name;
  final String unit;

  const FormulaVariable({
    required this.symbol,
    required this.name,
    required this.unit,
  });

  String get display => '$symbol ($name)';
}

/// Extended metadata about a formula
class FormulaInfo {
  final String description;
  final String realWorldUses;
  final String history;
  final List<FormulaVariable> variables;

  const FormulaInfo({
    required this.description,
    required this.realWorldUses,
    required this.history,
    required this.variables,
  });
}

class Formula {
  final String title;
  final String category;
  final List<String> inputs;
  final FormulaResult Function(List<double> vars) evaluate;
  final List<void Function(List<double>, FormulaResult)>? validators;
  final FormulaInfo? info;

  Formula({
    required this.title,
    required this.category,
    required this.inputs,
    required this.evaluate,
    this.validators,
    this.info,
  });

  /// Evaluates the formula with full error handling
  FormulaResult evaluateSafe(List<double> vars) {
    // Input count validation
    if (vars.length != inputs.length) {
      return FormulaResult.error('Expected ${inputs.length} inputs, got ${vars.length}');
    }

    // Check for NaN or Infinity in inputs
    for (int i = 0; i < vars.length; i++) {
      if (vars[i].isNaN || vars[i].isInfinite) {
        return FormulaResult.error('Input ${i + 1} is invalid');
      }
    }

    try {
      return evaluate(vars);
    } catch (e) {
      return FormulaResult.error('Calculation error: ${e.toString()}');
    }
  }
}

final List<Formula> allFormulas = [
  // --- PHYSICS ---
  Formula(
    title: "Force: F = m × a",
    category: "PHYSICS",
    inputs: ["Mass (kg)", "Accel (m/s²)"],
    evaluate: (v) => FormulaResult.success(v[0] * v[1]),
    info: const FormulaInfo(
      description: "Newton's Second Law states that force equals mass times acceleration. It's the fundamental equation of classical mechanics.",
      realWorldUses: "Used in engineering to calculate structural loads, vehicle acceleration, rocket thrust, and sports physics (e.g., kicking a ball).",
      history: "Formulated by Sir Isaac Newton in 1687 in his masterpiece 'Principia Mathematica'. It revolutionized physics and remained unchallenged for over 200 years.",
      variables: [
        FormulaVariable(symbol: "F", name: "Force", unit: "N (Newtons)"),
        FormulaVariable(symbol: "m", name: "Mass", unit: "kg"),
        FormulaVariable(symbol: "a", name: "Acceleration", unit: "m/s²"),
      ],
    ),
  ),
  Formula(
    title: "Kinematics: v = √(u² + 2as)",
    category: "PHYSICS",
    inputs: ["u (m/s)", "a (m/s²)", "s (m)"],
    evaluate: (v) {
      double result = v[0]*v[0] + 2*v[1]*v[2];
      if (result < 0) return FormulaResult.error('Negative under square root');
      return FormulaResult.success(MathOps.safeSqrt(result));
    },
    info: const FormulaInfo(
      description: "Calculates final velocity given initial velocity, acceleration, and displacement. Derived from kinematic equations of motion.",
      realWorldUses: "Used in automotive crash analysis, projectile motion, sports analytics, and determining landing speeds for aircraft.",
      history: "Developed from Galileo's experiments in the early 1600s, formalized by Newton in his laws of motion.",
      variables: [
        FormulaVariable(symbol: "v", name: "Final Velocity", unit: "m/s"),
        FormulaVariable(symbol: "u", name: "Initial Velocity", unit: "m/s"),
        FormulaVariable(symbol: "a", name: "Acceleration", unit: "m/s²"),
        FormulaVariable(symbol: "s", name: "Displacement", unit: "m"),
      ],
    ),
  ),
  Formula(
    title: "Weight: W = m × g",
    category: "PHYSICS",
    inputs: ["Mass (kg)", "Gravity (m/s²)"],
    evaluate: (v) => FormulaResult.success(v[0] * v[1]),
    info: const FormulaInfo(
      description: "Weight is the force of gravity acting on an object's mass. It varies with gravitational field strength.",
      realWorldUses: "Used in weighing scales, calculating shipping weights, determining load limits for bridges and elevators, and space missions.",
      history: "Newton established that gravity acts equally on all masses. The standard gravity (9.80665 m/s²) was defined by the International Bureau of Weights and Measures.",
      variables: [
        FormulaVariable(symbol: "W", name: "Weight", unit: "N"),
        FormulaVariable(symbol: "m", name: "Mass", unit: "kg"),
        FormulaVariable(symbol: "g", name: "Gravitational Acceleration", unit: "m/s²"),
      ],
    ),
  ),
  Formula(
    title: "Work Done: W = F × d",
    category: "PHYSICS",
    inputs: ["Force (N)", "Dist (m)"],
    evaluate: (v) => FormulaResult.success(v[0] * v[1]),
    info: const FormulaInfo(
      description: "Work is energy transferred when a force moves an object over a distance. Only the component of force parallel to displacement counts.",
      realWorldUses: "Used in calculating energy consumption, crane operations, pushing objects, and understanding engine performance.",
      history: "The concept was formalized by Gaspard-Gustave de Coriolis in 1826. The unit 'joule' was named after James Prescott Joule.",
      variables: [
        FormulaVariable(symbol: "W", name: "Work", unit: "J (Joules)"),
        FormulaVariable(symbol: "F", name: "Force", unit: "N"),
        FormulaVariable(symbol: "d", name: "Distance", unit: "m"),
      ],
    ),
  ),
  Formula(
    title: "Power: P = W / t",
    category: "PHYSICS",
    inputs: ["Work (J)", "Time (s)"],
    evaluate: (v) {
      if (v[1] == 0) return FormulaResult.error('Time cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0], v[1]));
    },
    info: const FormulaInfo(
      description: "Power is the rate at which work is done or energy is transferred. It determines how quickly tasks can be completed.",
      realWorldUses: "Used to compare engine performance, household appliances, power plants, and athletes' output. Essential for electric vehicle design.",
      history: "The watt unit was named after James Watt (1736-1819) for his improvements to the steam engine. Horsepower was coined by James Watt to compare engine power to horses.",
      variables: [
        FormulaVariable(symbol: "P", name: "Power", unit: "W (Watts)"),
        FormulaVariable(symbol: "W", name: "Work", unit: "J"),
        FormulaVariable(symbol: "t", name: "Time", unit: "s"),
      ],
    ),
  ),
  Formula(
    title: "Momentum: p = m × v",
    category: "PHYSICS",
    inputs: ["Mass (kg)", "Veloc (m/s)"],
    evaluate: (v) => FormulaResult.success(v[0] * v[1]),
    info: const FormulaInfo(
      description: "Linear momentum is the product of mass and velocity. It's a conserved quantity in closed systems.",
      realWorldUses: "Used in collision analysis, vehicle safety design (crumple zones), particle physics, and sports (baseball bat swing, football tackle).",
      history: "Descartes initially proposed the concept, but Newton formalized it in Principia. Conservation of momentum is one of the most fundamental laws in physics.",
      variables: [
        FormulaVariable(symbol: "p", name: "Momentum", unit: "kg·m/s"),
        FormulaVariable(symbol: "m", name: "Mass", unit: "kg"),
        FormulaVariable(symbol: "v", name: "Velocity", unit: "m/s"),
      ],
    ),
  ),
  Formula(
    title: "Ohm's Law: V = I × R",
    category: "PHYSICS",
    inputs: ["Current (A)", "Resist (Ω)"],
    evaluate: (v) => FormulaResult.success(v[0] * v[1]),
    info: const FormulaInfo(
      description: "Ohm's Law describes the relationship between voltage, current, and resistance in electrical circuits. It's the foundation of electrical engineering.",
      realWorldUses: "Used in designing all electrical circuits, understanding phone charging, LED brightness, and household wiring. Essential for electronics.",
      history: "Discovered by Georg Simon Ohm in 1827. He was initially ridiculed for his mathematical approach, but his law became fundamental. The ohm unit was named in his honor in 1861.",
      variables: [
        FormulaVariable(symbol: "V", name: "Voltage", unit: "V (Volts)"),
        FormulaVariable(symbol: "I", name: "Current", unit: "A (Amperes)"),
        FormulaVariable(symbol: "R", name: "Resistance", unit: "Ω (Ohms)"),
      ],
    ),
  ),
  Formula(
    title: "Pressure: P = F / A",
    category: "PHYSICS",
    inputs: ["Force (N)", "Area (m²)"],
    evaluate: (v) {
      if (v[1] == 0) return FormulaResult.error('Area cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0], v[1]));
    },
    info: const FormulaInfo(
      description: "Pressure is force distributed over an area. Higher pressure with same force comes from smaller contact area.",
      realWorldUses: "Used in hydraulic systems, knife sharpening (sharper = smaller area), shoe design, tire pressure, and scuba diving.",
      history: "Blaise Pascal (1623-1662) established the principles of fluid pressure. The pascal (Pa) unit was named after him in 1971.",
      variables: [
        FormulaVariable(symbol: "P", name: "Pressure", unit: "Pa (Pascals)"),
        FormulaVariable(symbol: "F", name: "Force", unit: "N"),
        FormulaVariable(symbol: "A", name: "Area", unit: "m²"),
      ],
    ),
  ),
  Formula(
    title: "Density: ρ = m / V",
    category: "PHYSICS",
    inputs: ["Mass (kg)", "Vol (m³)"],
    evaluate: (v) {
      if (v[1] == 0) return FormulaResult.error('Volume cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0], v[1]));
    },
    info: const FormulaInfo(
      description: "Density is mass per unit volume. It determines whether objects float or sink in fluids.",
      realWorldUses: "Used in material selection, ship design, oil spill response, brewing (wort gravity), and gem identification.",
      history: "Archimedes discovered the principle of buoyancy while taking a bath (c. 250 BCE). He reportedly ran naked through the streets shouting 'Eureka!'",
      variables: [
        FormulaVariable(symbol: "ρ", name: "Density", unit: "kg/m³"),
        FormulaVariable(symbol: "m", name: "Mass", unit: "kg"),
        FormulaVariable(symbol: "V", name: "Volume", unit: "m³"),
      ],
    ),
  ),
  Formula(
    title: "Speed: s = d / t",
    category: "PHYSICS",
    inputs: ["Dist (m)", "Time (s)"],
    evaluate: (v) {
      if (v[1] == 0) return FormulaResult.error('Time cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0], v[1]));
    },
    info: const FormulaInfo(
      description: "Speed is the rate at which an object covers distance. Unlike velocity, it doesn't consider direction.",
      realWorldUses: "Used in GPS navigation, sports timing, traffic analysis, and calculating travel times. Speed cameras use this principle.",
      history: "Galileo was first to measure speed scientifically in the early 1600s. The concept evolved from ancient observations of motion.",
      variables: [
        FormulaVariable(symbol: "s", name: "Speed", unit: "m/s"),
        FormulaVariable(symbol: "d", name: "Distance", unit: "m"),
        FormulaVariable(symbol: "t", name: "Time", unit: "s"),
      ],
    ),
  ),
  Formula(
    title: "Kinetic Energy: KE = ½mv²",
    category: "PHYSICS",
    inputs: ["Mass (kg)", "Veloc (m/s)"],
    evaluate: (v) => FormulaResult.success(0.5 * v[0] * v[1] * v[1]),
    info: const FormulaInfo(
      description: "Kinetic energy is the energy of motion. The ½ factor comes from integrating velocity over time during acceleration.",
      realWorldUses: "Used in crash test simulations, roller coaster design, particle accelerators, and calculating stopping distances for vehicles.",
      history: "Gottfried Wilhelm Leibniz introduced the concept of 'vis viva' (living force) in 1689. Gaspard-Gustave de Coriolis later formalized the ½mv² form.",
      variables: [
        FormulaVariable(symbol: "KE", name: "Kinetic Energy", unit: "J"),
        FormulaVariable(symbol: "m", name: "Mass", unit: "kg"),
        FormulaVariable(symbol: "v", name: "Velocity", unit: "m/s"),
      ],
    ),
  ),
  Formula(
    title: "Potential Energy: PE = mgh",
    category: "PHYSICS",
    inputs: ["Mass (kg)", "Gravity (m/s²)", "Height (m)"],
    evaluate: (v) => FormulaResult.success(v[0] * v[1] * v[2]),
    info: const FormulaInfo(
      description: "Gravitational potential energy is energy stored due to an object's position in a gravitational field.",
      realWorldUses: "Used in hydroelectric dams, pendulum clocks, bungee jumping, and calculating satellite orbital energy.",
      history: "The concept was developed through the work of Galileo, Newton, and was formalized by Lord Kelvin in the 19th century.",
      variables: [
        FormulaVariable(symbol: "PE", name: "Potential Energy", unit: "J"),
        FormulaVariable(symbol: "m", name: "Mass", unit: "kg"),
        FormulaVariable(symbol: "g", name: "Gravity", unit: "m/s²"),
        FormulaVariable(symbol: "h", name: "Height", unit: "m"),
      ],
    ),
  ),
  Formula(
    title: "Electric Power: P = V² / R",
    category: "PHYSICS",
    inputs: ["Voltage (V)", "Resist (Ω)"],
    evaluate: (v) {
      if (v[1] == 0) return FormulaResult.error('Resistance cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0] * v[0], v[1]));
    },
    info: const FormulaInfo(
      description: "Electrical power in a circuit equals voltage squared divided by resistance. Derived from Ohm's Law and P=IV.",
      realWorldUses: "Used in designing circuits, calculating phone charging time, understanding light bulb brightness, and power grid design.",
      history: "Derived from Ohm's Law (1827) and Joule's Law (1841). James Prescott Joule discovered the relationship between electrical and heat energy.",
      variables: [
        FormulaVariable(symbol: "P", name: "Power", unit: "W"),
        FormulaVariable(symbol: "V", name: "Voltage", unit: "V"),
        FormulaVariable(symbol: "R", name: "Resistance", unit: "Ω"),
      ],
    ),
  ),

  // --- CHEMISTRY ---
  Formula(
    title: "Ideal Gas: P = nRT / V",
    category: "CHEMISTRY",
    inputs: ["n (mol)", "T (K)", "V (m³)"],
    evaluate: (v) {
      if (v[2] == 0) return FormulaResult.error('Volume cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0] * 8.314 * v[1], v[2]));
    },
    info: const FormulaInfo(
      description: "The ideal gas law relates pressure, volume, temperature, and amount of gas. It assumes ideal behavior (no intermolecular forces).",
      realWorldUses: "Used in chemical engineering, weather forecasting, scuba diving gas calculations, and understanding respiratory mechanics.",
      history: "Émile Clapeyron combined Boyle's (1662), Charles's (1787), and Avogadro's (1811) laws into a single equation in 1834.",
      variables: [
        FormulaVariable(symbol: "P", name: "Pressure", unit: "Pa"),
        FormulaVariable(symbol: "n", name: "Moles", unit: "mol"),
        FormulaVariable(symbol: "R", name: "Gas Constant", unit: "8.314 J/(mol·K)"),
        FormulaVariable(symbol: "T", name: "Temperature", unit: "K"),
        FormulaVariable(symbol: "V", name: "Volume", unit: "m³"),
      ],
    ),
  ),
  Formula(
    title: "Molarity: M = n / V",
    category: "CHEMISTRY",
    inputs: ["Moles (mol)", "Vol (L)"],
    evaluate: (v) {
      if (v[1] == 0) return FormulaResult.error('Volume cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0], v[1]));
    },
    info: const FormulaInfo(
      description: "Molarity is the most common measure of concentration, expressing moles of solute per liter of solution.",
      realWorldUses: "Used in titrations, preparing chemical solutions, IV fluids in medicine, and laboratory chemistry.",
      history: "The concept developed from mole theory. The term 'molar' comes from Latin 'moles' meaning 'mass'.",
      variables: [
        FormulaVariable(symbol: "M", name: "Molarity", unit: "mol/L (M)"),
        FormulaVariable(symbol: "n", name: "Moles of solute", unit: "mol"),
        FormulaVariable(symbol: "V", name: "Volume", unit: "L"),
      ],
    ),
  ),
  Formula(
    title: "Moles: n = m / M",
    category: "CHEMISTRY",
    inputs: ["Mass (g)", "Molar Mass (g/mol)"],
    evaluate: (v) {
      if (v[1] == 0) return FormulaResult.error('Molar mass cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0], v[1]));
    },
    info: const FormulaInfo(
      description: "Calculates the number of moles from mass and molar mass. The mole is the SI base unit for amount of substance.",
      realWorldUses: "Used in stoichiometry, drug dosage calculations, industrial chemical production, and nutrition labels.",
      history: "The mole concept was introduced by Wilhelm Ostwald in 1896. Avogadro's number (6.022×10²³) was determined by Loschmidt, then refined by Millikan and others.",
      variables: [
        FormulaVariable(symbol: "n", name: "Moles", unit: "mol"),
        FormulaVariable(symbol: "m", name: "Mass", unit: "g"),
        FormulaVariable(symbol: "M", name: "Molar Mass", unit: "g/mol"),
      ],
    ),
  ),
  Formula(
    title: "pH: pH = -log[H⁺]",
    category: "CHEMISTRY",
    inputs: ["[H⁺] (mol/L)"],
    evaluate: (v) {
      if (v[0] <= 0) return FormulaResult.error('Concentration must be positive');
      double logVal = MathOps.safeLog(v[0]);
      if (logVal.isNaN) return FormulaResult.error('Invalid concentration value');
      return FormulaResult.success(-logVal / ln10);
    },
    info: const FormulaInfo(
      description: "pH measures acidity/basicity on a logarithmic scale. Each unit represents a 10-fold change in hydrogen ion concentration.",
      realWorldUses: "Used in water quality testing, blood pH monitoring, soil analysis, food preservation, and swimming pool maintenance.",
      history: "Introduced by Søren Sørensen in 1909 while working at Carlsberg Laboratory. The 'p' prefix stands for 'potenz' (German for power) or 'negative log'.",
      variables: [
        FormulaVariable(symbol: "pH", name: "pH Scale", unit: "dimensionless"),
        FormulaVariable(symbol: "[H⁺]", name: "Hydrogen ion concentration", unit: "mol/L"),
      ],
    ),
  ),
  Formula(
    title: "Enthalpy: Q = mcΔT",
    category: "CHEMISTRY",
    inputs: ["Mass (g)", "SpecHeat (J/gK)", "ΔT (K)"],
    evaluate: (v) => FormulaResult.success(v[0] * v[1] * v[2]),
    info: const FormulaInfo(
      description: "Heat enthalpy change equals mass times specific heat capacity times temperature change. Used in calorimetry.",
      realWorldUses: "Used in calorimetry experiments, designing heat exchangers, cooking science, and understanding climate change.",
      history: "The term 'enthalpy' was coined by Heike Kamerlingh Onnes in 1909. Specific heat capacities were first measured by Joseph Black in the 1760s.",
      variables: [
        FormulaVariable(symbol: "Q", name: "Heat", unit: "J"),
        FormulaVariable(symbol: "m", name: "Mass", unit: "g"),
        FormulaVariable(symbol: "c", name: "Specific Heat", unit: "J/(g·K)"),
        FormulaVariable(symbol: "ΔT", name: "Temperature Change", unit: "K"),
      ],
    ),
  ),
  Formula(
    title: "Charles's Law: V₂ = V₁T₂ / T₁",
    category: "CHEMISTRY",
    inputs: ["V₁", "T₁ (K)", "T₂ (K)"],
    evaluate: (v) {
      if (v[1] == 0) return FormulaResult.error('Initial temperature cannot be zero');
      if (v[1] < 0) return FormulaResult.error('Temperature must be positive (Kelvin)');
      return FormulaResult.success(MathOps.safeDivide(v[0] * v[2], v[1]));
    },
    info: const FormulaInfo(
      description: "Charles's Law states that volume of a gas is directly proportional to its temperature (in Kelvin) at constant pressure.",
      realWorldUses: "Used in hot air balloons, weather balloons, gas thermometers, and understanding lung expansion.",
      history: "Discovered by Jacques Charles in 1787. He was also the first to use hydrogen in balloons (1783).",
      variables: [
        FormulaVariable(symbol: "V₁", name: "Initial Volume", unit: "L"),
        FormulaVariable(symbol: "V₂", name: "Final Volume", unit: "L"),
        FormulaVariable(symbol: "T₁", name: "Initial Temperature", unit: "K"),
        FormulaVariable(symbol: "T₂", name: "Final Temperature", unit: "K"),
      ],
    ),
  ),
  Formula(
    title: "Boyle's Law: P₂ = P₁V₁ / V₂",
    category: "CHEMISTRY",
    inputs: ["P₁", "V₁", "V₂"],
    evaluate: (v) {
      if (v[2] == 0) return FormulaResult.error('Final volume cannot be zero');
      return FormulaResult.success(MathOps.safeDivide(v[0] * v[1], v[2]));
    },
    info: const FormulaInfo(
      description: "Boyle's Law states that pressure of a gas is inversely proportional to its volume at constant temperature.",
      realWorldUses: "Used in scuba diving (Boyle's law explains ascending dangers), syringes, bicycle pumps, and vacuum systems.",
      history: "Discovered by Robert Boyle in 1662. He published 'The Sceptical Chymist' which challenged Aristotelian element theory.",
      variables: [
        FormulaVariable(symbol: "P₁", name: "Initial Pressure", unit: "Pa"),
        FormulaVariable(symbol: "P₂", name: "Final Pressure", unit: "Pa"),
        FormulaVariable(symbol: "V₁", name: "Initial Volume", unit: "L"),
        FormulaVariable(symbol: "V₂", name: "Final Volume", unit: "L"),
      ],
    ),
  ),

  // --- MATH: COORDINATE GEOMETRY ---
  Formula(
    title: "Distance: √((x₂-x₁)² + (y₂-y₁)²)",
    category: "MATH",
    inputs: ["x1", "y1", "x2", "y2"],
    evaluate: (v) {
      double dx = v[2] - v[0];
      double dy = v[3] - v[1];
      return FormulaResult.success(MathOps.safeSqrt(dx * dx + dy * dy));
    },
    info: const FormulaInfo(
      description: "The Euclidean distance formula calculates the straight-line distance between two points in a plane using the Pythagorean theorem.",
      realWorldUses: "Used in GPS navigation, computer graphics, robotics path planning, and measuring distances on maps.",
      history: "Derived from Pythagoras's theorem (c. 570-495 BCE). Euclid formalized distance in his 'Elements' around 300 BCE.",
      variables: [
        FormulaVariable(symbol: "x₁, y₁", name: "First point coordinates", unit: ""),
        FormulaVariable(symbol: "x₂, y₂", name: "Second point coordinates", unit: ""),
      ],
    ),
  ),
  Formula(
    title: "Line Slope: (y₂-y₁) / (x₂-x₁)",
    category: "MATH",
    inputs: ["x1", "y1", "x2", "y2"],
    evaluate: (v) {
      double dx = v[2] - v[0];
      if (dx == 0) return FormulaResult.error('Vertical line (undefined slope)');
      return FormulaResult.success(MathOps.safeDivide(v[3] - v[1], dx));
    },
    info: const FormulaInfo(
      description: "Slope measures the steepness and direction of a line. Positive slope goes up, negative goes down, zero is horizontal, undefined is vertical.",
      realWorldUses: "Used in civil engineering (road grades), economics (supply/demand curves), physics (velocity-time graphs), and sports analytics.",
      history: "The concept of slope evolved from Cartesian geometry developed by René Descartes and Pierre de Fermat in the 1630s.",
      variables: [
        FormulaVariable(symbol: "m", name: "Slope", unit: ""),
        FormulaVariable(symbol: "x₁, y₁", name: "First point", unit: ""),
        FormulaVariable(symbol: "x₂, y₂", name: "Second point", unit: ""),
      ],
    ),
  ),
  Formula(
    title: "Midpoint: ((x₁+x₂)/2, (y₁+y₂)/2)",
    category: "MATH",
    inputs: ["x1", "y1", "x2", "y2"],
    evaluate: (v) {
      double mx = (v[0] + v[2]) / 2;
      double my = (v[1] + v[3]) / 2;
      return FormulaResult.success(0, isStringResult: true, stringValue: '(${_format(mx)}, ${_format(my)})');
    },
    info: const FormulaInfo(
      description: "The midpoint formula finds the exact center point between two coordinates in a plane.",
      realWorldUses: "Used in computer graphics (centers), navigation waypoints, architectural design, and game development.",
      history: "Derived from the average concept in statistics, formalized with Cartesian coordinates by Descartes.",
      variables: [
        FormulaVariable(symbol: "M", name: "Midpoint", unit: ""),
        FormulaVariable(symbol: "x₁, y₁", name: "First point", unit: ""),
        FormulaVariable(symbol: "x₂, y₂", name: "Second point", unit: ""),
      ],
    ),
  ),

  // --- MATH: ALGEBRA ---
  Formula(
    title: "Quadratic Pos Root",
    category: "MATH",
    inputs: ["a", "b", "c"],
    evaluate: (v) {
      if (v[0] == 0) return FormulaResult.error('Coefficient "a" cannot be zero');
      double discriminant = v[1]*v[1] - 4*v[0]*v[2];
      if (discriminant < 0) return FormulaResult.error('No real roots (discriminant < 0)');
      return FormulaResult.success(MathOps.safeDivide(-v[1] + MathOps.safeSqrt(discriminant), 2*v[0]));
    },
    info: const FormulaInfo(
      description: "The quadratic formula solves any quadratic equation ax² + bx + c = 0. This is the positive root (using +√).",
      realWorldUses: "Used in projectile motion, optimization problems, finance (NPV), engineering design, and computer graphics.",
      history: "Babylonian mathematicians solved quadratic equations around 2000 BCE. The complete formula was derived by al-Khwarizmi in 820 CE (the word 'algorithm' comes from his name).",
      variables: [
        FormulaVariable(symbol: "a", name: "Coefficient of x²", unit: ""),
        FormulaVariable(symbol: "b", name: "Coefficient of x", unit: ""),
        FormulaVariable(symbol: "c", name: "Constant term", unit: ""),
      ],
    ),
  ),
  Formula(
    title: "Quadratic Neg Root",
    category: "MATH",
    inputs: ["a", "b", "c"],
    evaluate: (v) {
      if (v[0] == 0) return FormulaResult.error('Coefficient "a" cannot be zero');
      double discriminant = v[1]*v[1] - 4*v[0]*v[2];
      if (discriminant < 0) return FormulaResult.error('No real roots (discriminant < 0)');
      return FormulaResult.success(MathOps.safeDivide(-v[1] - MathOps.safeSqrt(discriminant), 2*v[0]));
    },
    info: const FormulaInfo(
      description: "The quadratic formula's negative root. Quadratic equations have up to two solutions - this is the second one.",
      realWorldUses: "Used alongside the positive root in physics (projectile paths), engineering (resonance frequencies), and economics.",
      history: "Same as positive root - derived by al-Khwarizmi. The ± symbol was introduced by François Viète in 1593.",
      variables: [
        FormulaVariable(symbol: "a", name: "Coefficient of x²", unit: ""),
        FormulaVariable(symbol: "b", name: "Coefficient of x", unit: ""),
        FormulaVariable(symbol: "c", name: "Constant term", unit: ""),
      ],
    ),
  ),
  Formula(
    title: "Circle Area: A = π × r²",
    category: "MATH",
    inputs: ["Radius (r)"],
    evaluate: (v) {
      if (v[0] < 0) return FormulaResult.error('Radius cannot be negative');
      return FormulaResult.success(pi * v[0] * v[0]);
    },
    info: const FormulaInfo(
      description: "The area of a circle equals pi times radius squared. This is one of the most famous formulas in mathematics.",
      realWorldUses: "Used in calculating land areas, pizza sizes (value optimization), wheel design, and circular architecture.",
      history: "Archimedes proved this formula around 250 BCE using the 'method of exhaustion'. Pi (π) was first used by William Jones in 1706.",
      variables: [
        FormulaVariable(symbol: "A", name: "Area", unit: "πr²"),
        FormulaVariable(symbol: "π", name: "Pi", unit: "≈ 3.14159"),
        FormulaVariable(symbol: "r", name: "Radius", unit: ""),
      ],
    ),
  ),
  Formula(
    title: "Combinations: nCr",
    category: "MATH",
    inputs: ["n", "r"],
    evaluate: (v) {
      int n = v[0].floor();
      int r = v[1].floor();
      if (n < 0 || r < 0) return FormulaResult.error('Values must be non-negative');
      if (r > n) return FormulaResult.error('r cannot be greater than n');
      double result = MathOps.safeFactorial(n) / (MathOps.safeFactorial(r) * MathOps.safeFactorial(n - r));
      if (result.isNaN || result.isInfinite) return FormulaResult.error('Result too large');
      return FormulaResult.success(result);
    },
    info: const FormulaInfo(
      description: "Combinations count ways to select r items from n items where order doesn't matter. Written as 'n choose r'.",
      realWorldUses: "Used in lottery probability, team selection, card games, and statistical sampling.",
      history: "Blaise Pascal developed the binomial coefficients triangle in 1653. The notation nCr was introduced by Euler.",
      variables: [
        FormulaVariable(symbol: "n", name: "Total items", unit: ""),
        FormulaVariable(symbol: "r", name: "Items to choose", unit: ""),
        FormulaVariable(symbol: "nCr", name: "Combinations", unit: ""),
      ],
    ),
  ),
  Formula(
    title: "Permutations: nPr",
    category: "MATH",
    inputs: ["n", "r"],
    evaluate: (v) {
      int n = v[0].floor();
      int r = v[1].floor();
      if (n < 0 || r < 0) return FormulaResult.error('Values must be non-negative');
      if (r > n) return FormulaResult.error('r cannot be greater than n');
      double result = MathOps.safeFactorial(n) / MathOps.safeFactorial(n - r);
      if (result.isNaN || result.isInfinite) return FormulaResult.error('Result too large');
      return FormulaResult.success(result);
    },
    info: const FormulaInfo(
      description: "Permutations count ways to arrange r items from n items where order matters. More restrictive than combinations.",
      realWorldUses: "Used in password complexity, race rankings, scheduling problems, and lock combinations.",
      history: "Developed alongside combinations by mathematicians like Bernoulli and Leibniz in the 17th-18th centuries.",
      variables: [
        FormulaVariable(symbol: "n", name: "Total items", unit: ""),
        FormulaVariable(symbol: "r", name: "Items to arrange", unit: ""),
        FormulaVariable(symbol: "nPr", name: "Permutations", unit: ""),
      ],
    ),
  ),
  Formula(
    title: "Hypotenuse: c = √(a² + b²)",
    category: "MATH",
    inputs: ["a", "b"],
    evaluate: (v) => FormulaResult.success(MathOps.safeSqrt(v[0]*v[0] + v[1]*v[1])),
    info: const FormulaInfo(
      description: "The Pythagorean theorem states that in a right triangle, the square of the hypotenuse equals the sum of squares of the other two sides.",
      realWorldUses: "Used in construction (3-4-5 triangle), navigation, computer graphics, and any situation involving right angles.",
      history: "Named after Pythagoras (c. 570-495 BCE), but was known to Babylonians and Indians centuries earlier. Over 400 proofs exist - Einstein found one at age 12!",
      variables: [
        FormulaVariable(symbol: "c", name: "Hypotenuse", unit: ""),
        FormulaVariable(symbol: "a", name: "First leg", unit: ""),
        FormulaVariable(symbol: "b", name: "Second leg", unit: ""),
      ],
    ),
  ),

  // --- MATH: MATRICES & VECTORS ---
  Formula(
    title: "Vector Cross Mag: |a||b|sin(θ)",
    category: "MATH",
    inputs: ["|a|", "|b|", "θ (deg)"],
    evaluate: (v) {
      double angleRad = v[2] * pi / 180;
      return FormulaResult.success(v[0] * v[1] * sin(angleRad));
    },
    info: const FormulaInfo(
      description: "The magnitude of the cross product of two vectors equals the product of their magnitudes times the sine of the angle between them.",
      realWorldUses: "Used in physics (torque), computer graphics (surface normals), robotics, and calculating areas of parallelograms.",
      history: "Vector analysis was developed by Josiah Willard Gibbs and Oliver Heaviside in the 1880s for electromagnetic theory.",
      variables: [
        FormulaVariable(symbol: "|a|", name: "Magnitude of vector a", unit: ""),
        FormulaVariable(symbol: "|b|", name: "Magnitude of vector b", unit: ""),
        FormulaVariable(symbol: "θ", name: "Angle between vectors", unit: "degrees"),
      ],
    ),
  ),
  Formula(
    title: "Dot Product: a · b",
    category: "MATH",
    inputs: ["a1", "a2", "a3", "b1", "b2", "b3"],
    evaluate: (v) => FormulaResult.success(v[0]*v[3] + v[1]*v[4] + v[2]*v[5]),
    info: const FormulaInfo(
      description: "The dot product (scalar product) multiplies corresponding components and sums. It equals |a||b|cos(θ).",
      realWorldUses: "Used in determining if vectors are perpendicular (dot=0), computer graphics (lighting), and physics (work calculation).",
      history: "Introduced by Hermann Grassmann in 1844. William Rowan Hamilton developed the vector system in 1843.",
      variables: [
        FormulaVariable(symbol: "a", name: "Vector a", unit: ""),
        FormulaVariable(symbol: "b", name: "Vector b", unit: ""),
        FormulaVariable(symbol: "a·b", name: "Dot product", unit: ""),
      ],
    ),
  ),
  Formula(
    title: "2x2 Determinant: |A| = ad - bc",
    category: "MATH",
    inputs: ["a", "b", "c", "d"],
    evaluate: (v) => FormulaResult.success(v[0]*v[3] - v[1]*v[2]),
    info: const FormulaInfo(
      description: "The determinant of a 2x2 matrix is ad - bc. It represents the area scaling factor of the linear transformation.",
      realWorldUses: "Used in solving systems of equations, computer graphics (transformations), and checking matrix invertibility.",
      history: "The term 'determinant' was introduced by Gauss in 1801. Matrix theory was developed by Cayley, Hamilton, and Sylvester in the 1850s.",
      variables: [
        FormulaVariable(symbol: "a, b, c, d", name: "Matrix elements", unit: ""),
        FormulaVariable(symbol: "|A|", name: "Determinant", unit: ""),
      ],
    ),
  ),
];

/// Format number for display
String _format(double value) {
  if (value.isNaN) return 'NaN';
  if (value.isInfinite) return value > 0 ? '∞' : '-∞';
  if (value == value.roundToDouble() && value.abs() < 1e15) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(4).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}
