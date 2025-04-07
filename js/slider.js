document.addEventListener("DOMContentLoaded", () => {
    const imageFolder = 'images/gallery/';
    const imageList = ['alton.jpg', 'good.jpg', 'busy.jpg','build.webp']; // Add your image names here
    const slidesContainer = document.getElementById('slides');
  
    imageList.forEach(filename => {
      const img = document.createElement('img');
      img.src = imageFolder + filename;
      img.alt = filename;
      slidesContainer.appendChild(img);
    });
  });
  