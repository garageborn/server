#!/bin/bash
echo "# datadog"

DD_API_KEY=254ef51885e2a67c8b35fa041b5770a5 bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)"
