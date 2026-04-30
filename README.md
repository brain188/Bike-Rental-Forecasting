# Bike Rental Forecasting

[![Powered by Kedro](https://img.shields.io/badge/powered_by-kedro-ffc900?logo=kedro)](https://kedro.org)

## Overview

A real-time machine learning application that forecasts hourly bike rental demand using historical data. The project implements an end-to-end ML pipeline with feature engineering, model training, inference, and a live dashboard for monitoring predictions.

### Key Features

- **Real-time Forecasting**: Predicts bike rental demand for the next hour
- **Automated Pipeline**: Feature engineering, training, and inference pipelines
- **Live Dashboard**: Interactive web interface showing predictions vs actual values
- **Containerized Deployment**: Docker-based architecture with separate services
- **Model Flexibility**: Supports CatBoost and Random Forest algorithms

### Architecture

The application consists of three main components:

1. **ML Training Service**: Trains the forecasting model using historical data
2. **ML Inference Service**: Generates real-time predictions every second (simulating 1-hour intervals)
3. **Web UI Service**: Interactive dashboard displaying live predictions

### Technology Stack

- **ML Framework**: Kedro for pipeline orchestration
- **Model**: CatBoost (primary), Random Forest (alternative)
- **Web Interface**: Dash with Bootstrap components
- **Containerization**: Docker and Docker Compose
- **Data Format**: Parquet files for efficient storage

## Quick Start

### Using Docker (Recommended)

1. **Clone and navigate to the project**:

   ```bash
   git clone <repository-url>
   cd bike-rental-forecasting
   ```

2. **Run the complete application**:

   ```bash
   docker-compose up
   ```

3. **Access the dashboard**:
   Open your browser and go to `http://localhost:8050`

The Docker setup will automatically:

- Train the ML model
- Start the inference pipeline
- Launch the web dashboard

### Manual Setup

1. **Install dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

2. **Train the model**:

   ```bash
   python entrypoints/training.py
   ```

3. **Run inference** (in separate terminal):

   ```bash
   python entrypoints/inference.py
   ```

4. **Launch dashboard** (in separate terminal):

   ```bash
   python entrypoints/app_ui.py
   ```

## Project Structure

```

bike-rental-forecasting/
├── conf/                    # Configuration files
│   ├── base/
│   │   ├── catalog.yml     # Data catalog definitions
│   │   └── parameters.yml  # Model and pipeline parameters
│   └── local/              # Local configurations (credentials)
├── data/                   # Data storage (organized by processing stage)
│   ├── 01_raw/            # Raw input data
│   ├── 06_models/         # Trained models
│   └── 07_model_output/   # Predictions
├── entrypoints/           # Application entry points
│   ├── training.py        # Model training script
│   ├── inference.py       # Real-time inference script
│   └── app_ui.py          # Web dashboard launcher
├── src/
│   ├── bike_rental_forecasting/  # Core ML pipelines
│   │   └── pipelines/
│   │       ├── feature_eng.py    # Feature engineering
│   │       ├── training.py       # Model training
│   │       └── inference.py      # Prediction pipeline
│   └── app_ui/                   # Dashboard application
│       ├── app.py               # Main dashboard app
│       └── utils.py             # Utility functions
├── docker-compose.yml     # Multi-service deployment
└── Dockerfile            # Container definition
```

## Available Pipelines

The project includes three main pipelines:

### 1. Training Pipeline

```bash
kedro run --pipeline training
```

- Feature engineering for training data

- Model training with CatBoost
- Model validation and storage

### 2. Inference Pipeline

```bash
kedro run --pipeline inference

```

- Feature engineering for new data
- Real-time prediction generation
- Results storage

### 3. Default Pipeline

```bash
kedro run
```

- Combines feature engineering and training
- Used for initial model development

## Configuration

Key parameters can be modified in `conf/base/parameters.yml`:

- **Model Settings**: Algorithm choice, hyperparameters
- **Feature Engineering**: Lag features, column mappings
- **Training**: Train/test split, target definition
- **Inference**: Batch size, prediction intervals
- **UI**: Update frequency, display settings

## Model Performance

The CatBoost model is configured with:

- Learning rate: 0.2
- Depth: 6
- Iterations: 50 (configurable)
- Loss function: RMSE
- Features: Lagged bike counts, weather data, temporal features

## Data Pipeline

1. **Raw Data**: Historical bike rental data with weather information
2. **Feature Engineering**: Creates lag features, temporal features, and weather indicators
3. **Training**: Splits data and trains the forecasting model
4. **Inference**: Generates predictions for new time periods
5. **Visualization**: Real-time dashboard displays predictions vs actuals

## Monitoring

The web dashboard provides:

- Real-time prediction visualization
- Configurable time window (last N hours)
- Comparison between predicted and actual bike counts
- Automatic updates every 2 seconds



In order to get the best out of the template:

* Don't remove any lines from the `.gitignore` file we provide
* Make sure your results can be reproduced by following a data engineering convention
* Don't commit data to your repository
* Don't commit any credentials or your local configuration to your repository. Keep all your credentials and local configuration in `conf/local/`

## Rules and guidelines

In order to get the best out of the template:

* Don't remove any lines from the `.gitignore` file we provide
* Make sure your results can be reproduced by following a data engineering convention
* Don't commit data to your repository
* Don't commit any credentials or your local configuration to your repository. Keep all your credentials and local configuration in `conf/local/`

## How to install dependencies

Declare any dependencies in `requirements.txt` for `pip` installation.

To install them, run:

```
pip install -r requirements.txt
```

## How to run your Kedro pipeline

You can run your Kedro project with:

```
kedro run
```

## How to test your Kedro project

Have a look at the file `tests/test_run.py` for instructions on how to write your tests. You can run your tests as follows:

```
pytest
```

You can configure the coverage threshold in your project's `pyproject.toml` file under the `[tool.coverage.report]` section.


## Project dependencies

To see and update the dependency requirements for your project use `requirements.txt`. You can install the project requirements with `pip install -r requirements.txt`.

[Further information about project dependencies](https://docs.kedro.org/en/stable/kedro_project_setup/dependencies.html#project-specific-dependencies)

## How to work with Kedro and notebooks

> Note: Using `kedro jupyter` or `kedro ipython` to run your notebook provides these variables in scope: `context`, 'session', `catalog`, and `pipelines`.
>
> Jupyter, JupyterLab, and IPython are already included in the project requirements by default, so once you have run `pip install -r requirements.txt` you will not need to take any extra steps before you use them.

### Jupyter
To use Jupyter notebooks in your Kedro project, you need to install Jupyter:

```
pip install jupyter
```

After installing Jupyter, you can start a local notebook server:

```
kedro jupyter notebook
```

### JupyterLab
To use JupyterLab, you need to install it:

```
pip install jupyterlab
```

You can also start JupyterLab:

```
kedro jupyter lab
```

### IPython
And if you want to run an IPython session:

```
kedro ipython
```

### How to ignore notebook output cells in `git`
To automatically strip out all output cell contents before committing to `git`, you can use tools like [`nbstripout`](https://github.com/kynan/nbstripout). For example, you can add a hook in `.git/config` with `nbstripout --install`. This will run `nbstripout` before anything is committed to `git`.

> *Note:* Your output cells will be retained locally.

## Package your Kedro project

[Further information about building project documentation and packaging your project](https://docs.kedro.org/en/stable/deploy/package_a_project/#package-an-entire-kedro-project)
