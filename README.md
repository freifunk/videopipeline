# videopipeline
A service to upload and process videos towards media.freifunk.net

```mermaid
stateDiagram-v2
    [*] --> ProcessingPipeline
    note right of ProcessingPipeline
        Data is submitted via frontend by users
        We store the video and metadata as files on the server
    end note
    state ProcessingPipeline {
        state "Store video and metadata" as STORE
        state "Prepare Video" as PREPARE
        state "Convert videos in target formats" as PROCESS
        state "Store results on server" as RESULTS
        state "Notify admins about video to be published" as NOTIFY
        STORE --> PREPARE
        PREPARE --> PROCESS
        PROCESS --> RESULTS
        RESULTS --> NOTIFY
    }
    state PublishingStep {
        state "Accept or Deny" as ACCEPTANCE
        state choice <<choice>>
        ACCEPTANCE --> choice
        choice --> accepted
        choice --> denied
        accepted --> publish
        note right of accepted
            If we accept a video, a pipeline is triggered
            to publish the video the platforms we want
        end note
        publish --> cleanup
        denied --> cleanup
    }
    ProcessingPipeline --> PublishingStep
    note left of PublishingStep
        Admins get a link to a protected page,
        where they can find a preview and the metadata of the video
    end note

    PublishingStep --> [*]

    

```
## Installation of go-server and go-agent (Debian based Systems)
If you prefer to use the APT repository and install via apt-get, paste the following in your shell

```
echo "deb https://download.gocd.org /" | sudo tee /etc/apt/sources.list.d/gocd.list
curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo apt-key add -
sudo apt-get update
```
Once you have the added the repository to your sources list, execute the below command to install go-server
```
sudo apt install go-server
```
And execute the below command to install the go-agent
```
sudo apt install go-agent
```

## Changing server configuration
After the installtion of the server before starting the server we need to change the server configuration
Run the below command to change the configuration file
```
sudo nano /usr/share/go-server/wrapper-config/wrapper-properties.conf 
```
 By default, the server listens on 0.0.0.0, which is the wildcard or “unspecified” address. Usually, this means that the GoCD Server can be accessed through any network interface. In some, more advanced networking setups, it might be needed to override this, typically to 127.0.0.1, so that only clients local to the box can access it.
 
To configure the go-server to only listen on localhost add this line to the config file
```
wrapper.java.additional.100=-Dcruise.listen.host=127.0.0.1
```

## Starting the go-server and go-agent
After the installation and configuration of go-server and go-agent ,

Start running go-server using below command:
```
sudo systemctl start go-server
```
Start running go-agent using below command :
```
sudo systemctl start go-agent
```
Now go-server can be accessed at [http://localhost:8153](http://localhost:8153) 

## Setup Authentication
Setup the password file which will be used by the Password File Authentication plugin to store usernames and passwords

Use the below command for creating password file and a adding user 

```
sudo htpasswd -B -c /etc/go/password.properties vijay
```
<img width="847" alt="Screenshot 2022-06-24 at 10 10 17 PM" src="https://user-images.githubusercontent.com/44572780/175604753-bd090536-2cee-497b-94f3-4a3b2ec4cd0f.png">

Now head over to [http://localhost:8153](http://localhost:8153) to setup the authentication on GoCD server

1. Create an authorization configuration, by going to the “Admin” menu and then into “Security” and then “Authorization Configuration”.

2. Click on “Add” and provide any identifier (ID) for the configuration and then choose “Password File Authentication Plugin for GoCD”.

3. Provide the path to a password file on the GoCD server. Either absolute paths or paths relative to GoCD’s installation directory are accepted.

4. Specify allow only known users to login field.

<img width="1051" alt="Screenshot 2022-06-24 at 10 32 23 PM" src="https://user-images.githubusercontent.com/44572780/175608576-f705679f-5c6c-4a23-a8be-b64fa40de85a.png">


