# SecureAI CloudShield: Complete Development Guide

This document is your master blueprint for building the **SecureAI CloudShield** project from scratch. It breaks down the massive scope into manageable phases, provides exact technology choices, and details a realistic budget.

---

## 1. Complete Technology Stack & Tools Needed

Before writing any code, you need to set up your environment. Here is exactly what you need:

### Programming Languages
*   **Python 3.10+**: The core language for AI model training, data processing, and the backend API.
*   **JavaScript/TypeScript**: For building the frontend dashboard.

### Frameworks & Libraries
*   **AI/ML**: `scikit-learn` (for Isolation Forest), `xgboost` (for XGBoost), `pandas`, `numpy` (for data manipulation).
*   **Explainable AI (XAI)**: `shap` (SHapley Additive exPlanations) or `lime` to explain the AI predictions.
*   **Backend**: `FastAPI` (High-performance Python web framework), `uvicorn` (server), `python-jose` (JWT authentication), and `python-dotenv` (secrets management).
*   **Frontend**: `React.js` (using Vite for fast setup) or `Next.js`, styled with TailwindCSS. Use `socket.io-client` for real-time features.
*   **Database**: `PostgreSQL` (for storing user data and logs) using `SQLAlchemy` as the ORM.
*   **Testing**: `pytest` (Python backend tests), `Jest` + `React Testing Library` (frontend tests).

### Cloud & DevOps Tools
*   **AWS Services**: EC2 (hosting), S3 (storing datasets), CloudTrail (getting sample cloud logs), CloudWatch (monitoring), WAF (automated IP blocking).
*   **Containerization**: Docker & Docker Compose (to package your app so it runs anywhere).
*   **Reverse Proxy**: Nginx + Let's Encrypt Certbot (for HTTPS/SSL).
*   **CI/CD**: GitHub Actions (for automated deployment on every push to `main`).
*   **Version Control**: Git & GitHub.

> [!IMPORTANT]
> **Never hardcode AWS credentials in your code.** Always use IAM Roles for EC2 instances, or store keys in a `.env` file that is listed in `.gitignore`. Accidentally pushing AWS keys to GitHub can result in massive unexpected charges.

---

## 2. Exact Budget Breakdown (Realistic Estimation)

To keep costs low, you will **train the AI models locally** or on free cloud GPUs, and only deploy the final, lightweight application to AWS.

| Item | Platform / Service | Estimated Cost (INR) | Notes |
| :--- | :--- | :--- | :--- |
| **Model Training** | Google Colab / Kaggle | ₹0 | Use their free T4 GPUs for training. Do NOT train on AWS. |
| **Cloud Hosting (Backend/Frontend)** | AWS EC2 (t3.small or t3.medium) | ₹1,500 - ₹2,500 / month | You only need this running for 1-2 months during testing and presentation. |
| **Database Hosting** | AWS RDS (PostgreSQL Free Tier) or Supabase | ₹0 - ₹500 / month | Supabase provides a great free Postgres database. AWS RDS Free Tier is valid for the **first 12 months** of a new account only. |
| **Domain Name (Optional)** | Namecheap / GoDaddy | ₹800 - ₹1,000 / year | E.g., `secureai-cloudshield.com` |
| **Cloud Storage (Datasets)** | AWS S3 | ₹200 / month | Standard storage for logs and model weights. |
| **Data Egress (Transfer Costs)** | AWS EC2 / S3 | ₹200 - ₹500 / month | Charges for data sent OUT from AWS (API responses, downloads). Often overlooked. |
| **Total Estimated Project Cost** | | **₹2,700 - ₹4,700** | Much lower than your ₹18k estimate! |

> [!TIP]
> Use the **GitHub Student Developer Pack**. It gives you free domain names, AWS credits, and premium tools for free, which can bring your cost down to almost zero.

---

## 3. Step-by-Step Development Procedure

Follow these phases sequentially. Do not move to the next phase until the current one is working.

### Phase 1: Environment Setup & Data Gathering (Weeks 1-2)

1.  **Install Tools**: Install VS Code, Python 3.10+, Node.js, and Docker on your laptop.

2.  **Create a Virtual Environment** *(Do this before installing any Python package)*:
    ```bash
    # Create the virtual environment
    python -m venv venv

    # Activate it (Windows)
    venv\Scripts\activate

    # Activate it (Mac/Linux)
    source venv/bin/activate

    # Install all dependencies
    pip install scikit-learn xgboost pandas numpy shap fastapi uvicorn python-jose python-dotenv pytest
    pip freeze > requirements.txt
    ```

3.  **Download Datasets**:
    *   Download the **CICIDS2017** or **UNSW-NB15** dataset from Kaggle. These are CSV files containing network traffic data (some normal, some attacks).

    > [!NOTE]
    > The CICIDS2017 dataset is large (~7 GB total). For quick initial iteration and testing, start with the **Friday-WorkingHours** subset only (~500 MB), which contains DDoS and web attacks — the most relevant for this project.

    *   Find sample AWS CloudTrail log datasets on GitHub.

4.  **Setup Git**: Create a GitHub repository named `SecureAI-CloudShield` and push your initial empty folders (`/backend`, `/frontend`, `/ai-models`).

5.  **Create a `.env` file** in `/backend` for secrets and add it to `.gitignore` immediately:
    ```
    # .env  (NEVER commit this file)
    AWS_ACCESS_KEY_ID=your_key_here
    AWS_SECRET_ACCESS_KEY=your_secret_here
    JWT_SECRET_KEY=your_random_jwt_secret
    DATABASE_URL=postgresql://user:password@host/dbname
    ```
    ```
    # .gitignore
    venv/
    .env
    *.pkl
    *.joblib
    __pycache__/
    ```

---

### Phase 2: AI Model Development (The "Brain") (Weeks 3-6)
*Do this entirely in Jupyter Notebooks (locally or on Google Colab).*

1.  **Data Preprocessing**: Load the CSV datasets using `pandas`. Handle missing values, normalize numerical columns (like packet sizes), and encode categorical data (like IP addresses or protocols).
    ```python
    from sklearn.model_selection import train_test_split
    from sklearn.preprocessing import StandardScaler

    X = df.drop('Label', axis=1)
    y = df['Label']

    # Always split BEFORE fitting the scaler to prevent data leakage
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    scaler = StandardScaler()
    X_train = scaler.fit_transform(X_train)
    X_test = scaler.transform(X_test)  # Use transform only, NOT fit_transform
    ```

2.  **Model 1 - Anomaly Detection**: Train an **Isolation Forest** model to detect unusual network traffic (zero-day attacks).

3.  **Model 2 - Threat Classification**: Train an **XGBoost** classifier to categorize known attacks (e.g., DDoS, SQLi, Brute Force).

4.  **Evaluate Your Models** *(Do NOT skip this step)*:
    ```python
    from sklearn.metrics import classification_report, roc_auc_score, confusion_matrix

    y_pred = model.predict(X_test)
    print(classification_report(y_test, y_pred))
    print("AUC-ROC Score:", roc_auc_score(y_test, model.predict_proba(X_test)[:, 1]))
    print("Confusion Matrix:\n", confusion_matrix(y_test, y_pred))
    ```
    > [!IMPORTANT]
    > Target at least **95% F1-score** on test data. If accuracy is high but F1 is low, your model is biased towards the majority class — use `class_weight='balanced'` in XGBoost to fix this.

5.  **Explainability (XAI)**: Integrate the `shap` library. Pass your XGBoost model into SHAP to generate a graph showing *why* a specific network packet was flagged as a threat (e.g., "Flagged as DDoS because packet_rate > 1000").

6.  **Export Models**: Save your trained models and the scaler as `.joblib` files so your backend can use them.
    ```python
    import joblib
    joblib.dump(xgb_model, 'models/threat_classifier.joblib')
    joblib.dump(scaler, 'models/scaler.joblib')  # Save the scaler too!
    ```

---

### Phase 3: Backend API Development (Weeks 7-9)
*This is the bridge between your AI and your Dashboard.*

1.  **Setup FastAPI**: Create a basic Python FastAPI app.

2.  **Manage Secrets with `.env`**:
    ```python
    # backend/config.py
    from dotenv import load_dotenv
    import os

    load_dotenv()
    JWT_SECRET = os.getenv("JWT_SECRET_KEY")
    DATABASE_URL = os.getenv("DATABASE_URL")
    ```

3.  **Load Models**: Write code to load your saved `.joblib` AI models when the server starts.

4.  **Create Endpoints**:
    *   `POST /auth/login`: Accepts credentials and returns a JWT token.
    *   `POST /analyze/network` **(JWT Required)**: Accepts JSON network data, runs it through XGBoost, and returns `{"status": "Threat", "type": "DDoS", "confidence": "98%"}`.
    *   `GET /explain/{id}` **(JWT Required)**: Returns the SHAP explainability metrics for a specific threat.
    *   `WS /ws/live-traffic`: **WebSocket endpoint** that streams real-time analysis results to the frontend dashboard.

5.  **Automated Response Logic**: Write a simple Python function that triggers if a severe threat is detected. For example, if a DDoS is detected from IP `1.2.3.4`, the Python script can use the `boto3` library to automatically update an AWS WAF (Web Application Firewall) to block that IP.
    ```python
    import boto3

    def block_ip_in_waf(ip_address: str):
        # boto3 automatically picks up credentials from IAM Role (on EC2)
        # or from environment variables (local dev) — never hardcode them
        client = boto3.client('wafv2', region_name='us-east-1')
        # ... add IP to WAF IP set
    ```

6.  **Write Backend Unit Tests**:
    ```bash
    # Run tests with:
    pytest tests/ -v
    ```

---

### Phase 4: Frontend Dashboard Development (Weeks 10-12)
*This is what the user/admin sees.*

1.  **Setup React with Vite**:
    ```bash
    # Note the extra '--' separator before --template (required in newer npm versions)
    npm create vite@latest frontend -- --template react
    cd frontend
    npm install
    npm install axios socket.io-client
    ```

2.  **UI Design**: Use a library like Material-UI (MUI) or TailwindCSS to create a dark-mode, hacker-style dashboard.

3.  **Key Screens**:
    *   **Overview Map**: Shows where attacks are coming from.
    *   **Live Traffic Log**: A scrolling table showing network packets being analyzed in real-time. Connect this via **WebSocket** (`socket.io-client`) to the `/ws/live-traffic` endpoint — do NOT use REST polling for real-time data.
    *   **Alerts Panel**: Pops up red when a threat is detected.
    *   **Explainability Modal**: When you click an alert, it shows the SHAP graph explaining *why* the AI flagged it.

4.  **Connect to Backend**: Use `axios` for REST API calls and `socket.io-client` for the real-time live traffic feed:
    ```javascript
    // Real-time WebSocket connection example
    import { io } from 'socket.io-client';

    const socket = io('https://your-api-domain.com');
    socket.on('traffic_event', (data) => {
      setTrafficLog(prev => [data, ...prev].slice(0, 100)); // Keep latest 100 rows
    });
    ```

---

### Phase 5: Cloud Deployment & DevOps (Weeks 13-14)

1.  **Dockerize**: Create a `Dockerfile` for your FastAPI backend and another `Dockerfile` for your React frontend. Create a `docker-compose.yml` to run them together.

2.  **AWS EC2**: Spin up an Ubuntu EC2 instance on AWS. Assign it an **IAM Role** with WAF and S3 permissions — do not use access key files on the server.

3.  **Setup HTTPS with Nginx + Certbot** *(Do this BEFORE going live — browsers block insecure WebSocket and API connections)*:
    ```bash
    sudo apt install nginx certbot python3-certbot-nginx -y
    sudo certbot --nginx -d yourdomain.com
    ```
    Configure Nginx as a reverse proxy:
    *   `yourdomain.com/api/*` → FastAPI (port 8000)
    *   `yourdomain.com/ws/*` → WebSocket (port 8000)
    *   `yourdomain.com/*` → React build (static files)

4.  **Deploy**: SSH into your EC2 instance, clone your GitHub repo, and run `docker-compose up -d`. Your platform is now live on the internet!

5.  **Setup CI/CD with GitHub Actions** *(Automates deployment on every push to `main`)*:

    Create `.github/workflows/deploy.yml`:
    ```yaml
    name: Deploy to EC2
    on:
      push:
        branches: [main]
    jobs:
      deploy:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v3
          - name: SSH and Deploy
            uses: appleboy/ssh-action@master
            with:
              host: ${{ secrets.EC2_HOST }}
              username: ubuntu
              key: ${{ secrets.EC2_SSH_KEY }}
              script: |
                cd SecureAI-CloudShield
                git pull origin main
                docker-compose up -d --build
    ```

6.  **Monitor with AWS CloudWatch**: Set up CloudWatch alarms to alert you if CPU usage exceeds 80% or if the API returns too many 5xx errors. This helps catch issues before your project demo.

---

## 4. Key APIs and Libraries to Learn

To succeed, spend a few days reading the documentation for these specific tools:

1.  **Pandas & Scikit-Learn** (Python): For handling the datasets and training the models.
2.  **SHAP (SHapley Additive exPlanations)** (Python): This is the magic behind the "Explainable AI" part of your title.
3.  **FastAPI** (Python): It is much faster and easier for ML projects than Django or Flask.
4.  **Boto3** (Python): The official AWS SDK for Python. You will use this to automate responses (e.g., isolating a compromised EC2 instance or blocking an IP in WAF automatically).
5.  **Socket.IO** (Python + JavaScript): For the real-time WebSocket connection between backend and frontend dashboard.
6.  **python-jose** (Python): For generating and validating JWT tokens to secure your API endpoints.

---

## 5. Next Steps for You

1.  **Start with Phase 1 & 2**: Do not worry about React, AWS, or APIs right now. Your very first task is to:
    *   Create a virtual environment
    *   Open Google Colab or Jupyter Notebook locally
    *   Download the CICIDS2017 Friday subset (~500 MB)
    *   Successfully train an XGBoost model and print its classification report with F1-score

2.  Once that is working, we can start building the FastAPI backend around it.

3.  Keep your `.env` file safe and **never commit it to GitHub**.
