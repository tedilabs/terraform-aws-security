#!/usr/bin/env sh

curl https://a.b.cdn.console.awsstatic.com/a/v1/775YGM4M3SHLVWHBMZMAQNPI5LE3J2LYXJ5DISHSLQR4LRANT23A/managed-rules.json -o raw.json
cat raw.json | jq '
  [
    .[] | {
      id: .identifier,
      default_name: .defaultName,
      description: .description,
      is_ready: .isReadyToUse,
      supported_evaluation_modes: (.supportedEvaluationModes | map(.evaluationMode)),
      parameters: {
        required: .compulsoryInputParameterDetails,
        optional: .optionalInputParameterDetails
      },
      trigger_by_change: {
        enabled: (.sourceDetails | map(.messageType == "ConfigurationItemChangeNotification" or .messageType == "OversizedConfigurationItemChangeNotification") | any(.) ),
        scope: (if (.scope != null)
            then {
              resource_types: .scope.ResourceTypes
            }
            else null
          end),
      },
      trigger_by_schedule: {
        enabled: (.sourceDetails | map(.messageType == "ScheduledNotification") | any(.) ),
        max_frequency: (if (.sourceDetails[].messageType == "ScheduledNotification")
            then ((.sourceDetails[].maximumExecutionFrequencyMinutes // 1440) / 60 | tostring + "h")
            else null
          end),
      },
      labels: .labels
    }
  ] | INDEX(.default_name)'
