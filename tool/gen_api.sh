#!/usr/bin/env bash
# Regenerates packages/fluentpet_api from the running backend's OpenAPI spec.
#   tool/gen_api.sh [spec-url]        default http://localhost:8080/openapi.json
# Needs Java (Android Studio's JBR is used when JAVA_HOME is unset) and npx.
set -euo pipefail
cd "$(dirname "$0")/.."
SPEC_URL="${1:-http://localhost:8080/openapi.json}"
OUT=packages/fluentpet_api
SPEC="$OUT.openapi.json"
export JAVA_HOME="${JAVA_HOME:-/Applications/Android Studio.app/Contents/jbr/Contents/Home}"
export PATH="$JAVA_HOME/bin:$PATH"

mkdir -p packages
curl -sf "$SPEC_URL" -o "$SPEC"
python3 - "$SPEC" <<'PY'
import json, sys
path = sys.argv[1]
d = json.load(open(path))
# FastAPI's default ids are "get_me_api_v1_me_get"; keep the route's function name.
# Auth arrives as explicit optional header params on every route; drop them and
# declare bearer auth once so the generated client carries the token itself.
for ops in d["paths"].values():
    for op in ops.values():
        op["operationId"] = op["operationId"].split("_api_v1_")[0]
        op["parameters"] = [p for p in op.get("parameters", [])
                            if not (p["in"] == "header" and p["name"].lower() in ("authorization", "x-login-as"))]
# An object-valued default (SearchIn.filters) comes out as a broken Dart literal,
# and an enum default is looked up by its Dart name, so "occurred_at_desc" throws
# at construction. Neither default is load-bearing; the app sets every field.
for schema in d["components"]["schemas"].values():
    for prop in schema.get("properties", {}).values():
        if isinstance(prop.get("default"), dict) or "enum" in prop:
            prop.pop("default", None)
d["components"]["securitySchemes"] = {"bearer": {"type": "http", "scheme": "bearer"}}
d["security"] = [{"bearer": []}]
json.dump(d, open(path, "w"), indent=1)
PY

rm -rf "$OUT"
npx -y @openapitools/openapi-generator-cli generate \
  -i "$SPEC" -g dart-dio -o "$OUT" \
  --additional-properties=pubName=fluentpet_api,pubVersion=0.1.0 \
  --global-property=apiTests=false,modelTests=false,apiDocs=false,modelDocs=false
rm -f "$SPEC" "$OUT/git_push.sh"
cat > "$OUT/analysis_options.yaml" <<'YML'
# Generated code; its lint noise is not ours to fix. Kept out of `flutter analyze`.
analyzer:
  errors:
    unused_import: ignore
    duplicate_import: ignore
    unused_element_parameter: ignore
YML
(cd "$OUT" && dart pub get >/dev/null && dart run build_runner build --delete-conflicting-outputs >/dev/null && dart format . >/dev/null)
echo "generated $OUT"
