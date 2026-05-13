#!/usr/bin/env bash
set -euo pipefail

download_if_missing () {
  local url="$1"
  local relpath="$2"
  local filename="$3"
  local fullpath="/comfyui/${relpath}/${filename}"

  mkdir -p "/comfyui/${relpath}"

  if [ -f "$fullpath" ]; then
    echo "[INFO] Model already exists: $fullpath"
    return 0
  fi

  echo "[INFO] Downloading $filename to /comfyui/${relpath}"

  local backoffs=(10 20 30 60 90)
  for i in "${!backoffs[@]}"; do
    if HF_TOKEN="${HF_TOKEN:-}" comfy model download \
      --url "$url" \
      --relative-path "$relpath" \
      --filename "$filename"; then
      echo "[INFO] Downloaded: $filename"
      return 0
    fi

    if [ "$i" -eq 4 ]; then
      echo "[ERROR] Failed downloading $filename after 5 attempts" >&2
      exit 1
    fi

    sleep_sec="${backoffs[$i]}"
    echo "[WARN] Download failed for $filename; retrying in ${sleep_sec}s" >&2
    sleep "$sleep_sec"
  done
}

download_if_missing "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors" "models/latent_upscale_models" "ltx-2.3-spatial-upscaler-x2-1.0.safetensors"

download_if_missing "https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-dev-fp8.safetensors" "models/checkpoints" "ltx-2-19b-dev-fp8.safetensors"

download_if_missing "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-22b-dev.safetensors" "models/checkpoints" "ltx-2.3-22b-dev.safetensors"

download_if_missing "https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it.safetensors" "models/text_encoders" "gemma_3_12B_it.safetensors"

download_if_missing "https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors" "models/Unknown" "gemma_3_12B_it_fp8_e4m3fn.safetensors"

download_if_missing "https://huggingface.co/AviadDahan/LTX-2.3-ID-LoRA-TalkVid-3K/resolve/main/lora_weights.safetensors" "models/loras" "ltx-2.3-id-lora-talkvid-3k.safetensors"

download_if_missing "https://huggingface.co/rahul7star/Ltx-2-3-Lora-Collection/resolve/f79a7ffc9a0868739405fe3416698088afab0f7d/LTX2.3_Reasoning_V1.safetensors" "models/loras" "LTX2.3_Reasoning_V1.safetensors"

echo "[INFO] Starting Runpod ComfyUI worker"
exec python -u /rp_handler.py
