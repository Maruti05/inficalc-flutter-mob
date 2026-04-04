class Formula {
  final String title;
  final String category;
  final List<String> inputs;
  final String formula;

  Formula({
    required this.title,
    required this.category,
    required this.inputs,
    required this.formula,
  });
}

final List<Formula> allFormulas = [
  // --- PHYSICS ---
  Formula(title: "Force: F = m * a", category: "PHYSICS", inputs: ["Mass (kg)", "Accel (m/s²)"], formula: "m * a"),
  Formula(title: "Kinematics: v² = u² + 2as", category: "PHYSICS", inputs: ["u (m/s)", "a (m/s²)", "s (m)"], formula: "sqrt(u*u + 2*a*s)"),
  Formula(title: "Weight: W = m * g", category: "PHYSICS", inputs: ["Mass (kg)", "Gravity (m/s²)"], formula: "m * g"),
  Formula(title: "Work Done: W = F * d", category: "PHYSICS", inputs: ["Force (N)", "Dist (m)"], formula: "f * d"),
  Formula(title: "Power: P = W / t", category: "PHYSICS", inputs: ["Work (J)", "Time (s)"], formula: "w / t"),
  Formula(title: "Momentum: p = m * v", category: "PHYSICS", inputs: ["Mass (kg)", "Veloc (m/s)"], formula: "m * v"),
  Formula(title: "Ohm's Law: V = I * R", category: "PHYSICS", inputs: ["Current (A)", "Resist (Ω)"], formula: "i * r"),
  Formula(title: "Pressure Area: P = F / A", category: "PHYSICS", inputs: ["Force (N)", "Area (m²)"], formula: "f / a"),
  Formula(title: "Density: ρ = m / V", category: "PHYSICS", inputs: ["Mass (kg)", "Vol (m³)"], formula: "m / v"),

  // --- CHEMISTRY ---
  Formula(title: "Ideal Gas: P = nRT / V", category: "CHEMISTRY", inputs: ["n (mol)", "T (K)", "V (m³)"], formula: "n * 8.314 * t / v"),
  Formula(title: "Molarity: M = n / V", category: "CHEMISTRY", inputs: ["Moles (mol)", "Vol (L)"], formula: "n / v"),
  Formula(title: "Moles: n = m / M", category: "CHEMISTRY", inputs: ["Mass (g)", "Molar Mass (g/mol)"], formula: "m / mm"),
  Formula(title: "pH Measurement: pH = -log[H+]", category: "CHEMISTRY", inputs: ["[H+] (mol/L)"], formula: "-log(h)"),
  Formula(title: "Enthalpy Calc: Q = mcΔT", category: "CHEMISTRY", inputs: ["Mass (g)", "SpecHeat (J/gK)", "ΔT (K)"], formula: "m * c * dt"),

  // --- MATH: COORDINATE GEOMETRY ---
  Formula(title: "Distance: √((x2-x1)² + (y2-y1)²)", category: "MATH", inputs: ["x1", "y1", "x2", "y2"], formula: "sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))"),
  Formula(title: "Line Slope: (y2-y1) / (x2-x1)", category: "MATH", inputs: ["x1", "y1", "x2", "y2"], formula: "(y2-y1)/(x2-x1)"),
  Formula(title: "Point Midpoint: ((x1+x2)/2, (y1+y2)/2)", category: "MATH", inputs: ["x1", "x2", "y1", "y2"], formula: "((x1+x2)/2, (y1+y2)/2)"),

  // --- MATH: ALGEBRA ---
  Formula(title: "Quadratic: ax² + bx + c = 0", category: "MATH", inputs: ["a", "b", "c"], formula: "(-b + sqrt(b*b - 4*a*c)) / (2*a)"), // Pos root
  Formula(title: "Circle Area: A = π * r²", category: "MATH", inputs: ["Radius (r)"], formula: "3.14159 * r * r"),
  Formula(title: "Combinations: nCr", category: "MATH", inputs: ["n", "r"], formula: "fact(n) / (fact(r) * fact(n-r))"),
  Formula(title: "Permutations: nPr", category: "MATH", inputs: ["n", "r"], formula: "fact(n) / fact(n-r)"),

  // --- MATH: MATRICES & VECTORS ---
  Formula(title: "Vector Angle: |a|*|b|*sin(θ)", category: "MATH", inputs: ["|a|", "|b|", "θ (deg)"], formula: "a * b * sin(theta * 3.14159 / 180)"),
  Formula(title: "Dot Product: a · b", category: "MATH", inputs: ["a1", "a2", "a3", "b1", "b2", "b3"], formula: "a1*b1 + a2*b2 + a3*b3"),
  Formula(title: "2x2 Determinant: |A| = ad - bc", category: "MATH", inputs: ["a", "b", "c", "d"], formula: "a*d - b*c"),
];
