{{/*
    usage: {{ include "envValue" (list name value valueFrom isSlice) }}

    description:
      envValue will generate a container.env entry based off the passed arguments.

      An entry is only rendered if one of the values is not empty.

    arguments:
      name       environment variable name
      value      static value. if slice, it is converted to a space separated string.
      valueFrom  source the value from another resource. (overrides value)
      isSlice    (optional) if true when value is used, commas are replaced with spaces.

    example:
      {{ include "envValue" (list "EMAILS" "user1@example.com,user2@example.com" "" true) }}

    result:
      - name: "EMAILS"
        value: "user1@example.com user2@example.com"
*/}}
{{- define "envValue" }}
  {{- $name := index . 0 }}
  {{- $value := index . 1 }}
  {{- $valueFrom := index . 2 }}
  {{- $isSlice := false }}
  {{- if eq (len . ) 4 }}
    {{- $isSlice = index . 3 }}
  {{- end }}
  {{- if or $value $valueFrom }}
- name: {{ $name | quote }}
    {{- if $valueFrom }}
  valueFrom: {{- toYaml $valueFrom | nindent 4 }}
    {{- else }}
      {{- if eq (kindOf $value) "slice" }}
  value: {{ join " " $value | quote }}
      {{- else if $isSlice }}
  value: {{ regexReplaceAll "," (toString $value) " " | quote }}
      {{- else }}
  value: {{ $value | quote }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
