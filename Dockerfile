FROM runpod/worker-comfyui:5.8.4-base

# install custom nodes into comfyui
RUN git clone https://github.com/kijai/ComfyUI-KJNodes /comfyui/custom_nodes/ComfyUI-KJNodes && \
    cd /comfyui/custom_nodes/ComfyUI-KJNodes && \
    (git checkout 068d4fee62d379723dd96dd3e768ed807f7d7135 2>/dev/null || \
     (git fetch origin 068d4fee62d379723dd96dd3e768ed807f7d7135 --depth=1 && git checkout 068d4fee62d379723dd96dd3e768ed807f7d7135) || \
     echo "WARN: commit unreachable, falling back to default branch HEAD")

RUN git clone https://github.com/yolain/ComfyUI-Easy-Use /comfyui/custom_nodes/ComfyUI-Easy-Use && \
    cd /comfyui/custom_nodes/ComfyUI-Easy-Use && \
    (git checkout d9c2072a2de5f51ef9898ec50ccd4dda82e16126 2>/dev/null || \
     (git fetch origin d9c2072a2de5f51ef9898ec50ccd4dda82e16126 --depth=1 && git checkout d9c2072a2de5f51ef9898ec50ccd4dda82e16126) || \
     echo "WARN: commit unreachable, falling back to default branch HEAD")

RUN git clone https://github.com/cubiq/ComfyUI_essentials /comfyui/custom_nodes/ComfyUI_essentials && \
    cd /comfyui/custom_nodes/ComfyUI_essentials && \
    (git checkout 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 2>/dev/null || \
     (git fetch origin 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 --depth=1 && git checkout 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9) || \
     echo "WARN: commit unreachable, falling back to default branch HEAD")

RUN git clone https://github.com/evanspearman/ComfyMath /comfyui/custom_nodes/ComfyMath && \
    cd /comfyui/custom_nodes/ComfyMath && \
    (git checkout c01177221c31b8e5fbc062778fc8254aeb541638 2>/dev/null || \
     (git fetch origin c01177221c31b8e5fbc062778fc8254aeb541638 --depth=1 && git checkout c01177221c31b8e5fbc062778fc8254aeb541638) || \
     echo "WARN: commit unreachable, falling back to default branch HEAD")

RUN comfy node install --exit-on-fail comfyui-videohelpersuite@1.7.9 --mode remote || \
    (echo "WARN: comfyui-videohelpersuite@1.7.9 unavailable, falling back to latest" >&2 && \
     comfy node install --exit-on-fail comfyui-videohelpersuite --mode remote)

RUN mkdir -p /comfyui/input && \
    wget --progress=dot:giga -O "/comfyui/input/2026-05-05 230352-gpt-image-2.png" \
    "https://cool-anteater-319.convex.cloud/api/storage/99ee5647-5ebb-482d-9bcc-f06ea2510f07"

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
