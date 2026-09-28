from pydantic_settings import BaseSettings, SettingsConfigDict

class AnalyticsSettings(BaseSettings):
    """Configuration settings for Phase 5 Analytics Engine."""

    # Execution Gap Settings
    MIN_CASE_DURATION_SAMPLE_SIZE: int = 10     # Min closed cases required for P5 percentile calculation
    REPETITION_REVIEW_THRESHOLD: int = 3         # Min distinct cases with matching notes for repeated pattern

    # Anomaly Settings
    MIN_ANOMALY_OBSERVATION_DAYS: int = 10       # Min active calendar days for MAD Z-score anomaly calculation
    MAD_MODIFIED_Z_THRESHOLD: float = 3.5        # Modified Z-Score cutoff for MAD anomaly detection

    # Peer Benchmarking Settings
    MIN_PEER_GROUP_SIZE: int = 3                # Min CSEs required in sector group (else POPULATION_ALL fallback)
    BENCHMARK_SIGMA_THRESHOLD: float = 2.0       # Standard deviation threshold for peer benchmark finding
    MIN_ALERT_BENCHMARK_DENOMINATOR: int = 10    # Min total alerts for alert_investigation_rate
    MIN_CRITICAL_BENCHMARK_DENOMINATOR: int = 5   # Min critical alerts for critical_escalation_rate

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore"
    )

analytics_settings = AnalyticsSettings()
