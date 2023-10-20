# Connect Drozer to a Virtual Android Device

Follow these steps to connect Drozer to a virtual Android device. These instructions assume you have Docker, Docker Compose, and the Drozer APK ready.

1. **Install Drozer APK on the Virtual Device:**
   - Start your virtual Android device.
   - Connect to the virtual device using ADB:
     ```bash
     adb start-server
     adb devices
     ```
   - Download the Drozer Agent APK from:
     ```bash
     wget https://github.com/WithSecureLabs/drozer-agent/releases/download/2.5.2/agent-debug.apk
     ```
   - Install the Drozer Agent APK on the virtual device:
     ```bash
     adb install agent-debug.apk
     ```

2. **Enable the Drozer Agent on the Virtual Device:**
   - Open the Drozer Agent on your virtual Android device.
   - Enable the embedded server within the Drozer Agent.

3. **Forward Ports for Communication:**
   - Forward port 31415 from your virtual device to your host machine:
     ```bash
     adb forward tcp:31415 tcp:31415
     ```

4. **Start the Docker Container for Drozer:**
   - Ensure you have created a `docker-compose.yml` file with appropriate configurations.
   - Start the Docker container in the background:
     ```bash
     docker-compose up -d
     ```

5. **Connect to the Docker Container:**
   - Access a terminal within the Docker container:
     ```bash
     docker exec -it drozer-container /bin/bash
     ```

6. **Connect Drozer Console to the Virtual Android Device:**
   - Inside the Docker container, initiate a connection from Drozer to the virtual Android device using the host's loopback address. This allows Drozer to communicate with the Android device through the forwarded port:
     ```bash
     drozer console connect --server host.docker.internal
     ```

You are now ready to use Drozer to perform security assessments on your virtual Android device. 
