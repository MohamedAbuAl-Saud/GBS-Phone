# **SCAN PHONE TOOL**  
### **Designed by @A_Y_TR**  

---

## **Tool Description**  
"SCAN PHONE TOOL" is a powerful script designed to analyze phone numbers and provide detailed information, such as the associated country, network type, region, latitude, longitude, and service provider. It also generates a Google Maps link for accurate location visualization.

---

## **Features**  
- Validates the phone number.  
- Fetches detailed information including country, region, ISP, and carrier.  
- Displays GPS coordinates (latitude & longitude).  
- Provides a direct Google Maps link for location visualization.  

---

## **Requirements**  

### **Operating System**  
- Linux (e.g., Kali Linux, Ubuntu, Termux)  
- Windows (via WSL or Git Bash)  

### **Dependencies**  
- `curl`: For API requests.  
- `jq`: For parsing JSON data.  

---

## **Installation Instructions**

### **1. Automatic Installation**
The script includes automatic dependency installation. Run it, and it will verify if `curl` and `jq` are installed. If they’re missing, the script will install them for you.

If you want to install them manually, follow these steps:

#### **For Linux**
```bash
git clone https://github.com/MohamedAbuAl-Saud/GBS-Phone
cd GBS-Phone
chmod +x information-Phone.sh
bash information-Phone.sh
