<template>
  <div>
    <div id="app" class="web-camera-container">
      <div class="camera-button">
        <button type="button" class="button is-rounded"
          :class="{ 'is-primary': !isCameraOpen, 'is-danger': isCameraOpen }" @click="toggleCamera">
          <span v-if="!isCameraOpen">Open Camera</span>
          <span v-else>Close Camera</span>
        </button>
      </div>

      <div v-show="isCameraOpen && isLoading" class="camera-loading">
        <ul class="loader-circle">
          <li></li>
          <li></li>
          <li></li>
        </ul>
      </div>

      <div v-if="isCameraOpen" v-show="!isLoading" class="camera-box" :class="{ flash: isShotPhoto }">
        <div class="camera-shutter" :class="{ flash: isShotPhoto }"></div>

        <video v-show="!isPhotoTaken" ref="camera" :width="450" :height="337.5" autoplay></video>

        <canvas v-show="isPhotoTaken" id="photoTaken" ref="canvas" :width="450" :height="337.5"></canvas>
      </div>

      <div v-if="isCameraOpen && !isLoading" class="camera-shoot">
        <button type="button" class="button" @click="takePhoto">
          <img src="https://img.icons8.com/material-outlined/50/000000/camera--v2.png" />
        </button>
      </div>

      <div v-if="isPhotoTaken && isCameraOpen" class="camera-download">
        <a id="downloadPhoto" download="my-photo.jpg" class="button" role="button" @click="downloadImage">
          Download
        </a>
      </div>
      <div class="camera-button">
        <input type="file" @change="onFileChanged" />
        <button type="button" class="button is-rounded" @click="onUpload">
          <span>Upload Photo</span>
        </button>
      </div>
      <div>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam quis
        nulla a tellus sollicitudin suscipit. Aliquam erat volutpat. Suspendisse
        suscipit tellus a enim dictum malesuada. Maecenas turpis mauris, semper
        nec leo quis, consequat rutrum mi. Interdum et malesuada fames ac ante
        ipsum primis in faucibus. Donec finibus arcu eget ipsum consequat
        semper. Fusce facilisis orci eu tellus pharetra, ut dictum massa
        iaculis. Curabitur venenatis purus id cursus mattis. Sed est mauris,
        scelerisque id feugiat vitae, aliquet ma ka bhosda leo. Aliquam porta ut nisi at
        bibendum. Proin aliquet blandit velit, et sodales massa aliquam in. Sed
        maximus ante quis leo varius, vitae viverra erat hendrerit. Class aptent
        taciti sociosqu ad litora torquent per conubia nostra, per inceptos
        himenaeos. Pellentesque pulvinar ligula at leo accumsan euismod. Aenean
        faucibus laoreet diam, et faucibus urna rutrum ac.
      </div>
    </div>
  </div>
</template>

<script>
export default {
  el: '#app',

  data() {
    return {
      isCameraOpen: false,
      isPhotoTaken: false,
      isShotPhoto: false,
      isLoading: false,
      link: '#',
      selectedFile: null,
    }
  },

  methods: {
    toggleCamera() {
      if (this.isCameraOpen) {
        this.isCameraOpen = false
        this.isPhotoTaken = false
        this.isShotPhoto = false
        this.stopCameraStream()
      } else {
        this.isCameraOpen = true
        this.createCameraElement()
      }
    },

    createCameraElement() {
      this.isLoading = true

      const constraints = (window.constraints = {
        audio: false,
        video: true,
      })

      navigator.mediaDevices
        .getUserMedia(constraints)
        .then((stream) => {
          this.isLoading = false
          this.$refs.camera.srcObject = stream
        })
        .catch((_error) => {
          this.isLoading = false
          alert("May the browser didn't support or there is some errors.")
        })
    },

    stopCameraStream() {
      const tracks = this.$refs.camera.srcObject.getTracks()

      tracks.forEach((track) => {
        track.stop()
      })
    },

    takePhoto() {
      if (!this.isPhotoTaken) {
        this.isShotPhoto = true

        const FLASH_TIMEOUT = 50

        setTimeout(() => {
          this.isShotPhoto = false
        }, FLASH_TIMEOUT)
      }

      this.isPhotoTaken = !this.isPhotoTaken

      const context = this.$refs.canvas.getContext('2d')
      context.drawImage(this.$refs.camera, 0, 0, 450, 337.5)
    },

    downloadImage() {
      const download = document.getElementById('downloadPhoto')
      const canvas = document
        .getElementById('photoTaken')
        .toDataURL('image/jpeg')
        .replace('image/jpeg', 'image/octet-stream')
      download.setAttribute('href', canvas)
    },
    onFileChanged(event) {
      this.selectedFile = event.target.files[0]
    },
    onUpload($axios) {
      this.$axios.post('my-domain.com/file-upload', this.selectedFile)
    },
  },
}
</script>
<style>
body {
  display: flex;
  justify-content: center;
}

.web-camera-container {
  margin-top: 2rem;
  margin-bottom: 2rem;
  padding: 2rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  border: 1px solid #ccc;
  border-radius: 12px;
  width: 500px;
}

.web-camera-container .camera-button {
  margin-bottom: 2rem;
}

.web-camera-container .camera-box .camera-shutter {
  opacity: 0;
  width: 450px;
  height: 337.5px;
  background-color: #fff;
  position: absolute;
}

.web-camera-container .camera-box .camera-shutter.flash {
  opacity: 1;
}

.web-camera-container .camera-shoot {
  margin: 1rem 0;
}

.web-camera-container .camera-shoot button {
  height: 60px;
  width: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 100%;
}

.web-camera-container .camera-shoot button img {
  height: 35px;
  object-fit: cover;
}

.web-camera-container .camera-loading {
  overflow: hidden;
  height: 100%;
  position: absolute;
  width: 100%;
  min-height: 150px;
  margin: 3rem 0 0 -1.2rem;
}

.web-camera-container .camera-loading ul {
  height: 100%;
  position: absolute;
  width: 100%;
  z-index: 999999;
  margin: 0;
}

.web-camera-container .camera-loading .loader-circle {
  display: block;
  height: 14px;
  margin: 0 auto;
  top: 50%;
  left: 100%;
  transform: translateY(-50%);
  transform: translateX(-50%);
  position: absolute;
  width: 100%;
  padding: 0;
}

.web-camera-container .camera-loading .loader-circle li {
  display: block;
  float: left;
  width: 10px;
  height: 10px;
  line-height: 10px;
  padding: 0;
  position: relative;
  margin: 0 0 0 4px;
  background: #999;
  animation: preload 1s infinite;
  top: -50%;
  border-radius: 100%;
}

.web-camera-container .camera-loading .loader-circle li:nth-child(2) {
  animation-delay: 0.2s;
}

.web-camera-container .camera-loading .loader-circle li:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes preload {
  0% {
    opacity: 1;
  }

  50% {
    opacity: 0.4;
  }

  100% {
    opacity: 1;
  }
}

@media only screen and (max-width: 700px) {
  .web-camera-container {
    width: 350px;
  }

  .web-camera-container .camera-box .camera-shutter {
    width: 300px;
  }
}
</style>
