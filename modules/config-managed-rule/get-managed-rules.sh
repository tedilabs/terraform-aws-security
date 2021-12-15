#!/usr/bin/env sh

cat raw.json | jq '
  [
    .payload[] | {
      id: .identifier,
      default_name: .defaultName,
      description: .description,
      parameters: {
        required: .compulsoryInputParameterDetails,
        optional: .optionalInputParameterDetails
      },
      trigger_by_change: {
        enabled: (.sourceDetails | map(.messageType == "ConfigurationItemChangeNotification" or .messageType == "OversizedConfigurationItemChangeNotification") | any(.) ),
        scope: (if (.scope != null)
            then {
              resource_types: .scope.resourceTypes
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
