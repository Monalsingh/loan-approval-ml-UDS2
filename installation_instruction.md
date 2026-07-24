pip install -r requirements.txt

python -m streamlit run app.py

Start docker desktop

docker build -t loan-approval-app .

docker images

docker run -d -p 8501:8501 -p 8000:8000 loan-approval-app

docker ps -a

docker logs -f <container-id>
docker stop <container-id>

docker rm <container-id>
docker rmi <image-id>

<!-- docker run -d -p 8501:8501 loan-approval-app -->

aws.amazon.com --> primarily the public AWS website—product information, pricing, documentation, signup, etc.

console.aws.amazon.com --> This is the AWS Management Console, where you actually create resources. Inside the console, URLs may change depending on the service and region. the one i have is : "https://us-east-1.console.aws.amazon.com/"

https://signin.aws.amazon.com/ > "Sign in to console"

"Sign in using root user email" or "Create a new AWS account"

"Sign in using root user email" > EMAIL > PASSWORD > MFA CODE
monalkumar745@gmail.com
nimoyca@gmail.com
Hikalyani@123

Once done > On top right > Get Account-ID & UserName

Account-ID : 053125374515
User-Name : monal07
ARN : arn:aws:account::053125374515:account

Inside this account, there can be different identities:
    Root User : The email used to create AWS
        : The root user has full power over everything, including billing and account settings.
        : You should use it mainly for initial account setup and tasks that specifically require root access
        : not as your everyday AWS identity.
    IAM User : Optional individual AWS user
        : An IAM user is an identity you create inside your AWS account.
        : e.g. monal-admin
        : You can give monal-admin permissions to work with EC2, ECR, S3, etc.
    IAM Roles : Permissions given to AWS services
        : Ignore this for the moment.
        : EC2 > needs permission > ECR
        : Instead of storing AWS passwords/access keys on EC2, we attach an IAM role.

Go to AWS Management Console (Grid-ICON > Console Home)
AWS Management Console → search bar → service you need.

Top right > Region > Set your AWS Region
- India > ap-south-1
- Page might reload depending on which region you were in previously :
```https://ap-south-1.console.aws.amazon.com/```
- Signing in to anoyther region will show services you opted in that region :
AWS Account
├── Mumbai
│    └── EC2
│         └── loan-app-server ✓
│
└── Singapore
     └── EC2
          └── nothing

Search for EC2

EC2 — Virtual Servers in the Cloud

EC2 Dashboard > Instances > Launch instance

Form : 
    Name : loan-approval-server
    # This is just a human-readable name.

    Application and OS Images — AMI (Amazon Machine Image)
    : Ubuntu Server LTS
    ```
    AWS Hardware
     ↓
    Ubuntu Linux
        ↓
    Docker
        ↓
    Your Container
        ↓
    Streamlit ML App
    ```

    Instance type : t3.micro
    # Choose a small instance that the AWS launch screen shows as eligible under your account's current free-tier/free-credit offer, if available.

    # Don't assume a specific instance type is always free—AWS's free offers depend on account eligibility and can change.

    Key Pair:
    Key pair (login)
    # This is how you'll securely log into your EC2 server.
    - Create new key pair
    - Name : loan-app-key
    - Key pair type : RSA
    - Private key format : .pem
    - AWS will download : loan-app-key.pem
    # Keep this file safe.
    # Do not upload it to:
         - GitHub
         - or any public location
    # Later you'll use it to connect
        - ssh -i loan-app-key.pem ubuntu@PUBLIC-IP
    # Conceptually
    ```
    Your Computer

    loan-app-key.pem
        │
        │ proves identity
        ▼

    EC2 Server
    ```

    Network settings :
    - Don't manually design a VPC yet.
    - Use the defaults for your first learning deployment.
    - AWS will select/create networking such as :
        - VPC
        - Subnet
        - Public IP
    # The main thing you care about now is: Security Group
    # Think of a Security Group as a firewall.

    SSH traffic :
    - Allow SSH traffic from
        - SSH is how you remotely open a terminal on EC2.
    ```
    Your Laptop

    Terminal
    │
    │ SSH :22
    ▼

    EC2
    Ubuntu Terminal
    ```
    - For better security, select :
    - My IP --> rather than: Anywhere
    ```
    Inbound Rules

        ─────────────────────────────────────
        Type         Port       Source

        SSH          22         My IP

        Custom TCP   8501       0.0.0.0/0
        ─────────────────────────────────────
    ```
    - Storage : Configure storage > 
    Use a modest amount that fits your account's free/credit eligibility and project size; check the launch-page cost estimate.

    - Launch Instance > Launch instance
        - Instance State > Running

    - Understand what AWS just created
    ```
    AWS ACCOUNT

    └── Region
        │
        └── Mumbai
            │
            └── EC2
                │
                └── loan-approval-server
                        │
                        ├── Ubuntu
                        │
                        ├── CPU
                        │
                        ├── RAM
                        │
                        ├── Disk
                        │
                        ├── Public IP
                        │
                        └── Security Group
    ```

    - Connect to EC2
        - EC2 > Instances > loan-approval-server
            - Instance ID
            - Public IPv4 address (important one : 13.233.xxx.xxx)
            - Private IPv4 address
            - Public IPv4 DNS
            - Instance state

    - There are two ways to connect
        - EC2 Instance Connect
            - Instance > Connect > EC2 Instance Connect > Connect
                - AWS can open a terminal in your browser if the instance/network configuration supports it.
                - You'll see something like: ubuntu@ip-xxx-xxx-xxx:~$
                    - You are now inside the AWS computer
                    - This avoids dealing with .pem and local SSH commands initially.
        - SSH with your .pem

    - Now install Docker
        - Once you see: ubuntu@ip-xxx:~$
        - Follow instrcutions : https://docs.docker.com/engine/install/ubuntu
        - After installation, verify: docker --version
        - docker ps
            - If you get a permission denied error related to the Docker daemon, run: ```sudo usermod -aG docker $USER```
        - Then log out and reconnect to EC2 for the group change to take effect.
        - You can verify with: > ```docker ps```
        - Install GIT
            - ```git --version```
                - If it doesn't:
                    - sudo apt update
                    - sudo apt install git -y
                    - git --version
            - git clone YOUR_REPOSITORY_CLONE_URL
            - cd loan-approval-app
            - ls
            ```
            app.py
            loan_model.py
            requirements.txt
            Dockerfile
            models
            ```
            - ```docker build -t loan-approval-app:v1 .```
                # docker built -t give image a name/tag
            - This may take a few minutes the first time
            - When finished, run: ```docker images```
            ```
            docker run \
            -d \
            --name loan-app \
            --restart unless-stopped \
            -p 8501:8501 \
            loan-approval-app:v1
            ```

            or 

            ```
            docker run -d --name loan-app --restart unless-stopped -p 8501:8501 loan-approval-app:v1
            ```
            - Let's understand every part.
                - docker run : Create and start a container
                - -d : Run in background
                - --name loan-app : Container name = loan-app
                - --restart unless-stopped : 
                ```Restart automatically after
                server/container restart,
                unless manually stopped```
                - -p 8501:8501 : -p EC2 PORT : CONTAINER PORT
                - loan-approval-app:v1  : Use this Docker image

            - docker ps
            - abc123         loan-approval-app:v1     Up ...       0.0.0.0:8501->8501/tcp
            -  If docker ps shows nothing, don't rebuild randomly. Run:
                - docker ps -a > Exited (1)
                - docker logs loan-app
            - Test from inside EC2 first : curl http://localhost:8501
            - Find your EC2 public IP
                ```
                EC2
                ↓
                Instances
                ↓
                loan-approval-server
                ```
            - Public IPv4 address : 13.XXX.XXX.XXX
            - http://13.XXX.XXX.XXX:8501
            - But before opening it, make sure AWS allows port 8501.
                - In the EC2 instance details, find: Security > Security groups
                - Inbound rules > Edit inbound rules
                - or this learning deployment, you need : 
                    ```
                    | Type       | Port | Source      |
                    | ---------- | ---: | ----------- |
                    | SSH        |   22 | Your IP     |
                    | Custom TCP | 8501 | `0.0.0.0/0` |

                    ```
                - http://YOUR-EC2-PUBLIC-IP:8501
                - You should see:
                ```
                ┌──────────────────────────────────┐
                │                                  │
                │     Loan Approval Prediction     │
                │                                  │
                │ Number of Dependents  [       ]  │
                │                                  │
                │ Education             [       ]  │
                │                                  │
                │ Self Employed         [       ]  │
                │                                  │
                │ Annual Income         [       ]  │
                │                                  │
                │ Loan Amount           [       ]  │
                │                                  │
                │          [ Predict ]             │
                │                                  │
                └──────────────────────────────────┘`
                ```



