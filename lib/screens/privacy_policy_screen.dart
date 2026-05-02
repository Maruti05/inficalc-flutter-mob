import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  final String _markdownData = """
# Privacy Policy

We believe privacy is a fundamental right. Here's exactly how we handle your data — no legalese, just clarity.

## 1. Overview
Welcome to Vedica Labs ("we," "us," or "our"). We operate the Vedica Labs website, mobile applications including HireIQ, Veer Gym.
This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our Services. Please read this policy carefully. If you disagree with its terms, please discontinue use of our Services.

## 2. Information We Collect
We collect information in the following ways:

### Information You Provide Directly:
- Account registration data (name, email address, phone number)
- Profile information (photo, bio, professional details)
- Resume/CV uploads for HireIQ users
- Payment information (processed securely via Razorpay/Stripe — we never store card details)
- Support requests and feedback submissions
- Communications with our team

### Information Collected Automatically:
- Device identifiers (device type, OS version, app version)
- Usage data (features used, session duration, click events)
- IP address and approximate location (city/country level)
- Crash reports and performance diagnostics
- Referral source (how you found us)

### Information From Third Parties:
- Social login data if you sign in via Google or LinkedIn
- Analytics data from Firebase and Mixpanel

## 3. How We Use Your Data
We use your data solely to provide and improve our Services:
- Providing, personalizing, and improving our Services
- Processing transactions and sending related notices
- Sending service updates, security alerts, and support messages
- Analyzing usage patterns to improve product features
- Detecting and preventing fraud, abuse, and security incidents
- Complying with legal obligations
- Conducting research with your explicit consent

## 4. Data Sharing & Disclosure
We do not sell, trade, or rent your personal data. We may share data with:
- **Service Providers**: Trusted vendors who help us operate (e.g., AWS, Firebase, Razorpay) — bound by strict data processing agreements
- **Legal Requirements**: When required by law, court order, or governmental authority
- **Business Transfers**: In the event of a merger or acquisition — you will be notified in advance
- **With Your Consent**: For any other purpose with your explicit agreement

## 5. Data Storage & Security
Your data is stored on AWS servers located in Mumbai, India (ap-south-1 region) with encrypted backups in Singapore.
We implement industry-standard security measures including:
- AES-256 encryption at rest for all user data
- TLS 1.3 encryption in transit
- Multi-factor authentication for all internal systems
- Regular third-party security audits
- Strict role-based access control for employees
- Automated vulnerability scanning and patch management
We retain your data for as long as your account is active, or as needed to provide Services. You can request deletion at any time.

## 6. Your Rights
Under applicable laws (including India's DPDP Act 2023 and GDPR for EU residents), you have the right to:
- **Access**: Request a copy of the personal data we hold about you
- **Correction**: Update or correct inaccurate data
- **Deletion**: Request deletion of your account and all personal data
- **Portability**: Export your data in a machine-readable format
- **Objection**: Object to certain data processing activities
- **Withdraw Consent**: Revoke any previously given consent

To exercise any right, contact us at privacy@vedicalabs.in. We will respond within 30 days.

## 7. Cookies & Tracking Technologies
We use cookies and similar tracking technologies to enhance your experience. Types we use:
- **Essential Cookies**: Required for core functionality (cannot be disabled)
- **Analytics Cookies**: Help us understand how you use our Services (can be opted out)
- **Preference Cookies**: Remember your settings and preferences

We do not use advertising or marketing cookies. You can manage cookie preferences in your browser settings or via our cookie preference center.

## 8. Children's Privacy
Our Services are not directed to individuals under the age of 13 (or 18 in certain jurisdictions for some Services). We do not knowingly collect personal information from children.
If you are a parent or guardian and believe your child has provided us personal information, please contact us at privacy@vedicalabs.in and we will promptly delete such data.

## 9. Changes to This Policy
We may update this Privacy Policy periodically. We will notify you of significant changes via:
- Email notification to your registered address
- In-app notification banner
- A notice on our website homepage

Changes take effect 30 days after notification. Continued use after that period constitutes acceptance of the updated policy.

## 10. Contact Us
For privacy-related questions, data requests, or concerns:
- **Email**: privacy@vedicalabs.in
- **Data Protection Officer**: dpo@vedicalabs.in
- **Postal Address**: Vedica Labs, Dharwad, Karnataka 580001, India
- **Response Time**: Within 3 business days for standard queries

## 11. Terms of Service
By using Vedica Labs Services, you agree that:
- You are at least 13 years of age (18 for some Services)
- You will not misuse our Services for illegal purposes
- You will not reverse-engineer, scrape, or attempt to breach our systems
- You will not create multiple accounts to circumvent restrictions
- Account sharing is not permitted for individual plans
- We reserve the right to terminate accounts that violate these terms

Our Services are provided "as is." While we strive for 99.9% uptime, we make no guarantees of uninterrupted service. For complete Terms of Service, contact us at legal@vedicalabs.in.
""";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy'), centerTitle: false),
      body: Markdown(
        data: _markdownData,
        selectable: true,
        padding: const EdgeInsets.all(24),
        styleSheet: MarkdownStyleSheet(
          h1: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          h2: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            height: 2.0,
          ),
          h3: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurfaceVariant,
          ),
          p: textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
          listBullet: textTheme.bodyMedium,
        ),
      ),
    );
  }
}
