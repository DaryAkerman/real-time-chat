import os
import logging
from opencensus.ext.azure.log_exporter import AzureLogHandler
from opencensus.ext.azure.common import utils

def setup_logging(instrumentation_key):
    # Create a logger
    logger = logging.getLogger("flask_app_logger")
    logger.setLevel(logging.INFO)

    # Azure Log Handler
    azure_handler = AzureLogHandler(connection_string=f'InstrumentationKey={instrumentation_key}')
    azure_handler.add_telemetry_processor(add_custom_properties)

    # Console Handler
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_formatter = logging.Formatter(
        "[%(asctime)s] %(levelname)s in %(module)s: %(message)s"
    )
    console_handler.setFormatter(console_formatter)

    # Add both handlers to logger
    logger.addHandler(azure_handler)
    logger.addHandler(console_handler)

    return logger

def add_custom_properties(envelope):
    """ Add custom properties for each log. """
    envelope.tags['ai.cloud.role'] = 'FlaskApp'
    envelope.tags['ai.operation.name'] = 'UserActivity'
