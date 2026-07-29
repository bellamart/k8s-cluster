{{/*
Expand the name of the chart.
*/}}
{{- define "forgejo-runner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "forgejo-runner.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "forgejo-runner.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "forgejo-runner.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "forgejo-runner.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "forgejo-runner.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "forgejo-runner.selectorLabels" -}}
app.kubernetes.io/name: {{ include "forgejo-runner.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
