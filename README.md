<!DOCTYPE html>
<html>
<head>

</head>
<body>

<div class="header">
<h1>📡 Bat WiFi-Forcer</h1>
<p><em>Educational WiFi Security Testing Tool - Built with Batch Scripting</em></p>
</div>

<div class="warning">
⚠️ <strong>LEGAL DISCLAIMER:</strong> This tool is for <strong>educational purposes only</strong>. 
Unauthorized access to computer networks is illegal. Use only on networks you own or have explicit permission to test.
</div>

<h2>🌟 Overview</h2>
<p>Bat WiFi-Forcer is a proof-of-concept WiFi security testing tool written entirely in Windows Batch script. It demonstrates how basic brute-force concepts work while emphasizing ethical hacking principles.</p>

<div class="feature-box">
<h3>🚀 Features</h3>
<ul>
<li>🔍 <strong>Network Scanning</strong> - Discover available WiFi networks</li>
<li>🖥️ <strong>Interface Management</strong> - Select from multiple WiFi adapters</li>
<li>📋 <strong>Wordlist Support</strong> - Custom password dictionary attacks</li>
<li>🎯 <strong>Target Selection</strong> - Choose specific networks to test</li>
<li>📊 <strong>Progress Tracking</strong> - Real-time attack progress monitoring</li>
<li>📝 <strong>Logging</strong> - Detailed activity logs and results</li>
<li>🎨 <strong>Color Interface</strong> - Beautiful terminal colors and formatting</li>
</ul>
</div>

<h2>🛡️ Ethical Use</h2>
<div style="background: #e8f5e8; padding: 1rem; border-radius: 5px; border-left: 4px solid #48bb78;">
<p>✅ <strong>Allowed Uses:</strong></p>
<ul>
<li>Testing your own home networks</li>
<li>Educational demonstrations</li>
<li>Security research with permission</li>
<li>Learning about WiFi security</li>
</ul>

<p>❌ <strong>Prohibited Uses:</strong></p>
<ul>
<li>Unauthorized network access</li>
<li>Testing networks without permission</li>
<li>Malicious activities</li>
<li>Illegal hacking attempts</li>
</ul>
</div>

<h2>📦 Installation</h2>

<div class="code">
# Clone the repository
git clone https://github.com/voltsparx/Bat-WiFi-Forcer.git

# Navigate to directory
cd batch-wifi-bruteforcer

# Run the tool (as Administrator)
wififorcer.bat
</div>

<h2>🎮 Usage Examples</h2>

<div class="code">
# Scan for available networks
bruteforcer$ scan

# Set custom wordlist
bruteforcer$ wordlist C:\path\to\your\wordlist.txt

# Set attempt counter
bruteforcer$ counter 10

# Start attack
bruteforcer$ attack

# Show help
bruteforcer$ help
</div>

<h2>🛠️ Requirements</h2>
<table style="width: 100%; border-collapse: collapse;">
<tr style="background: #f7fafc;">
  <th style="padding: 10px; border: 1px solid #e2e8f0;">Component</th>
  <th style="padding: 10px; border: 1px solid #e2e8f0;">Requirement</th>
</tr>
<tr>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">🖥️ OS</td>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">Windows 7/8/10/11</td>
</tr>
<tr style="background: #f7fafc;">
  <td style="padding: 10px; border: 1px solid #e2e8f0;">⚡ Privileges</td>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">Administrator Rights</td>
</tr>
<tr>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">📡 Hardware</td>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">WiFi Adapter</td>
</tr>
<tr style="background: #f7fafc;">
  <td style="padding: 10px; border: 1px solid #e2e8f0;">🔧 Tools</td>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">netsh, wmic commands</td>
</tr>
</table>

<h2>📁 File Structure</h2>
<div class="code">
batch-wifi-bruteforcer/
├── 📄 wififorcer.bat      # Main batch script
├── 📄 wordlist.txt        # Default password dictionary
├── 📄 wifi_attack.log     # Activity logs
├── 📄 wifi_results.txt    # Successful results
├── 📄 README.md           # This documentation
└── 📄 LICENSE             # MIT License
</div>

<h2>⚡ Quick Start</h2>

<div style="background: #edf2f7; padding: 1.5rem; border-radius: 8px;">
<ol>
<li><strong>Run as Administrator</strong> - Right-click → "Run as administrator"</li>
<li><strong>Accept Terms</strong> - Read and accept the ethical use agreement</li>
<li><strong>Scan Networks</strong> - Use <code>scan</code> command to find targets</li>
<li><strong>Select Target</strong> - Choose a network from the scan results</li>
<li><strong>Configure</strong> - Set wordlist and attempt counter if needed</li>
<li><strong>Attack</strong> - Start testing with <code>attack</code> command</li>
<li><strong>Review Results</strong> - Check logs and results files</li>
</ol>
</div>

<h2>🔧 Configuration</h2>

<h3>Custom Wordlists</h3>
<p>Create your own wordlist file or use popular ones like:</p>
<ul>
<li>RockYou.txt</li>
<li>Common passwords lists</li>
<li>Custom dictionary files</li>
</ul>

<h3>Settings</h3>
<ul>
<li><code>counter</code> - Set connection attempt timeout</li>
<li><code>wordlist</code> - Specify custom password file</li>
<li><code>interface</code> - Select WiFi adapter</li>
</ul>

<h2>📊 Output Files</h2>
<table style="width: 100%; border-collapse: collapse;">
<tr style="background: #f7fafc;">
  <th style="padding: 10px; border: 1px solid #e2e8f0;">File</th>
  <th style="padding: 10px; border: 1px solid #e2e8f0;">Description</th>
</tr>
<tr>
  <td style="padding: 10px; border: 1px solid #e2e8f0;"><code>wifi_attack.log</code></td>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">Detailed timestamped activity log</td>
</tr>
<tr style="background: #f7fafc;">
  <td style="padding: 10px; border: 1px solid #e2e8f0;"><code>wifi_results.txt</code></td>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">Successful password findings</td>
</tr>
<tr>
  <td style="padding: 10px; border: 1px solid #e2e8f0;"><code>session_state.txt</code></td>
  <td style="padding: 10px; border: 1px solid #e2e8f0;">Saved session configuration</td>
</tr>
</table>

<h2>⚠️ Limitations</h2>
<div class="warning">
<p>This is an educational tool with several limitations:</p>
<ul>
<li>⏰ <strong>Slow performance</strong> - Batch scripting is not optimized for speed</li>
<li>📶 <strong>Online attacks only</strong> - No offline password cracking</li>
<li>🔒 <strong>WPA2 only</strong> - Doesn't support WPA3 or enterprise networks</li>
<li>📱 <strong>Basic functionality</strong> - Simplified security testing</li>
<li>🛡️ <strong>No stealth</strong> - Attacks are easily detectable</li>
</ul>
</div>

<h2>🤝 Contributing</h2>
<p>We welcome contributions! Please follow these guidelines:</p>
<ol>
<li>Fork the repository</li>
<li>Create a feature branch (<code>git checkout -b feature/amazing-feature</code>)</li>
<li>Commit your changes (<code>git commit -m 'Add amazing feature'</code>)</li>
<li>Push to the branch (<code>git push origin feature/amazing-feature</code>)</li>
<li>Open a Pull Request</li>
</ol>

<h2>📜 License</h2>
<p>This project is licensed under the MIT License - see the <a href="LICENSE">LICENSE</a> file for details.</p>

<h2>👨‍💻 Author</h2>
<p><strong>Voltsparx</strong></p>
<ul>
<li>GitHub: <a href="https://github.com/voltsparx">@voltsparx</a></li>
<li>Email: voltsparx@gmail.com</li>
<li>Website: <a href="https://github.com/voltsparx">More Projects</a></li>
</ul>

<h2>⭐ Support</h2>
<p>If you find this project useful, please give it a star on GitHub!</p>

<div style="text-align: center; margin: 2rem 0;">
<a href="https://github.com/voltsparx/batch-wifi-bruteforcer" class="btn">⭐ Star on GitHub</a>
<a href="https://github.com/voltsparx/batch-wifi-bruteforcer/fork" class="btn">🔱 Fork Project</a>
<a href="https://github.com/voltsparx/batch-wifi-bruteforcer/issues" class="btn">🐛 Report Issues</a>
</div>

<hr>
<p align="center">
<em>Made with 💻 and ❤️ for educational purposes</em>
</p>

</body>
</html>
