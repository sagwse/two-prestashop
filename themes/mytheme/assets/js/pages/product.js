/**
 * product.js — JavaScript страницы товара
 *
 * mytheme v0.7.2
 * Подключается через theme.yml → product controller → priority 110
 * Атрибут: defer (загрузка после парсинга HTML)
 *
 * Модули:
 *  1. Gallery:   смена главного фото, hover zoom, lightbox, mobile dots
 *  2. Variants:  обновлённый UI при PS9 updateProduct event
 *  3. Qty:       stepper (+/-), валидация min/max
 *  4. Accordion:  toggle info sections (mobile)
 *  5. Sticky Bar: IntersectionObserver для mobile sticky bottom bar
 *  6. Share:      Web Share API fallback
 *
 * Зависимости:
 *  - PS9 core.js (prestashop object, events)
 *  - Bootstrap 5.3 (для tooltips/modals если нужны)
 */

'use strict';

document.addEventListener('DOMContentLoaded', () => {

  /* =========================================================================
   * 1. GALLERY
   * ========================================================================= */

  // --- Desktop: thumbnail click → switch main image ---
  const mainImage = document.getElementById('js-main-product-image');
  const thumbnails = document.querySelectorAll('[data-action="switch-image"]');

  if (mainImage && thumbnails.length > 0) {
    thumbnails.forEach(thumb => {
      thumb.addEventListener('click', () => {
        const src = thumb.dataset.imageSrc;
        const largeSrc = thumb.dataset.imageLarge || src;

        if (src) {
          mainImage.src = src;
          mainImage.dataset.largeSrc = largeSrc;

          // Update active state
          thumbnails.forEach(t => t.classList.remove('product-gallery__thumb--active'));
          thumb.classList.add('product-gallery__thumb--active');
        }
      });
    });
  }

  // --- Desktop: hover zoom with mouse tracking ---
  const mainContainer = document.querySelector('.product-gallery__main');

  if (mainContainer && mainImage) {
    mainContainer.addEventListener('mousemove', (e) => {
      const rect = mainContainer.getBoundingClientRect();
      const x = ((e.clientX - rect.left) / rect.width) * 100;
      const y = ((e.clientY - rect.top) / rect.height) * 100;
      mainContainer.style.setProperty('--zoom-x', x + '%');
      mainContainer.style.setProperty('--zoom-y', y + '%');
    });
  }

  // --- Lightbox ---
  const lightbox = document.getElementById('js-product-lightbox');

  if (lightbox) {
    const lightboxImg = lightbox.querySelector('.product-lightbox__img');
    const lightboxCounter = lightbox.querySelector('.product-lightbox__counter');
    const lightboxClose = lightbox.querySelector('[data-action="close-lightbox"]');
    const lightboxPrev = lightbox.querySelector('[data-action="lightbox-prev"]');
    const lightboxNext = lightbox.querySelector('[data-action="lightbox-next"]');

    // Collect all product images
    const allImages = [];
    thumbnails.forEach(thumb => {
      allImages.push({
        src: thumb.dataset.imageLarge || thumb.dataset.imageSrc,
        alt: thumb.querySelector('img')?.alt || ''
      });
    });

    // If no thumbnails, use main image
    if (allImages.length === 0 && mainImage) {
      allImages.push({
        src: mainImage.dataset.largeSrc || mainImage.src,
        alt: mainImage.alt
      });
    }

    let currentLightboxIndex = 0;

    function updateLightbox() {
      if (lightboxImg && allImages[currentLightboxIndex]) {
        lightboxImg.src = allImages[currentLightboxIndex].src;
        lightboxImg.alt = allImages[currentLightboxIndex].alt;
      }
      if (lightboxCounter) {
        lightboxCounter.textContent = `${currentLightboxIndex + 1} / ${allImages.length}`;
      }
    }

    // Open lightbox
    const openLightboxBtn = document.querySelector('[data-action="open-lightbox"]');
    if (openLightboxBtn) {
      openLightboxBtn.addEventListener('click', () => {
        // Find current active thumbnail index
        const activeThumb = document.querySelector('.product-gallery__thumb--active');
        if (activeThumb) {
          currentLightboxIndex = Array.from(thumbnails).indexOf(activeThumb);
        }
        if (currentLightboxIndex < 0) currentLightboxIndex = 0;
        updateLightbox();
        lightbox.showModal();
      });
    }

    // Close
    if (lightboxClose) {
      lightboxClose.addEventListener('click', () => lightbox.close());
    }

    // Backdrop click to close
    lightbox.addEventListener('click', (e) => {
      if (e.target === lightbox) lightbox.close();
    });

    // Navigation
    if (lightboxPrev) {
      lightboxPrev.addEventListener('click', () => {
        currentLightboxIndex = (currentLightboxIndex - 1 + allImages.length) % allImages.length;
        updateLightbox();
      });
    }

    if (lightboxNext) {
      lightboxNext.addEventListener('click', () => {
        currentLightboxIndex = (currentLightboxIndex + 1) % allImages.length;
        updateLightbox();
      });
    }

    // Keyboard navigation in lightbox
    lightbox.addEventListener('keydown', (e) => {
      if (e.key === 'ArrowLeft' && lightboxPrev) lightboxPrev.click();
      if (e.key === 'ArrowRight' && lightboxNext) lightboxNext.click();
    });
  }

  // --- Mobile: scroll-snap dots update ---
  const mobileScroll = document.querySelector('.product-gallery__scroll');
  const mobileDots = document.querySelectorAll('.product-gallery__dot');

  if (mobileScroll && mobileDots.length > 0) {
    const slides = mobileScroll.querySelectorAll('.product-gallery__slide');

    // Update dots on scroll
    let scrollTimeout;
    mobileScroll.addEventListener('scroll', () => {
      clearTimeout(scrollTimeout);
      scrollTimeout = setTimeout(() => {
        const scrollLeft = mobileScroll.scrollLeft;
        const slideWidth = mobileScroll.offsetWidth;
        const activeIndex = Math.round(scrollLeft / slideWidth);

        mobileDots.forEach((dot, i) => {
          dot.classList.toggle('product-gallery__dot--active', i === activeIndex);
        });
      }, 50);
    });

    // Click dot → scroll to slide
    mobileDots.forEach((dot, i) => {
      dot.addEventListener('click', () => {
        const slideWidth = mobileScroll.offsetWidth;
        mobileScroll.scrollTo({
          left: slideWidth * i,
          behavior: 'smooth'
        });
      });
    });
  }


  /* =========================================================================
   * 2. VARIANTS — PrestaShop 9 updateProduct integration
   * ========================================================================= */

  // Listen for PS9 core event
  if (typeof prestashop !== 'undefined') {
    prestashop.on('updatedProduct', (event) => {
      // PS9 refreshes the entire product data
      // The page content updates automatically via PS core
      // We need to update our custom UI elements

      if (event && event.product_url) {
        // Update URL without reload
        window.history.replaceState({}, '', event.product_url);
      }
    });
  }

  // Update selected value display in variant labels
  const variantInputs = document.querySelectorAll('.product-variants__pill input[type="radio"]');

  variantInputs.forEach(input => {
    input.addEventListener('change', () => {
      const group = input.closest('.product-variants__group');
      if (group) {
        const selectedDisplay = group.querySelector('[data-selected-value]');
        const label = input.nextElementSibling;
        if (selectedDisplay && label) {
          selectedDisplay.textContent = label.textContent.trim();
        }
      }
    });
  });


  /* =========================================================================
   * 3. QUANTITY STEPPER
   * ========================================================================= */
  const qtyInput = document.getElementById('js-quantity-input');
  const qtyDecrease = document.querySelector('[data-action="decrease-qty"]');
  const qtyIncrease = document.querySelector('[data-action="increase-qty"]');

  if (qtyInput) {
    const min = parseInt(qtyInput.min) || 1;
    const max = parseInt(qtyInput.max) || 9999;

    function updateQtyButtons() {
      const val = parseInt(qtyInput.value) || min;
      if (qtyDecrease) qtyDecrease.disabled = val <= min;
      if (qtyIncrease) qtyIncrease.disabled = val >= max;
    }

    if (qtyDecrease) {
      qtyDecrease.addEventListener('click', () => {
        const current = parseInt(qtyInput.value) || min;
        if (current > min) {
          qtyInput.value = current - 1;
          qtyInput.dispatchEvent(new Event('change', { bubbles: true }));
          updateQtyButtons();
        }
      });
    }

    if (qtyIncrease) {
      qtyIncrease.addEventListener('click', () => {
        const current = parseInt(qtyInput.value) || min;
        if (current < max) {
          qtyInput.value = current + 1;
          qtyInput.dispatchEvent(new Event('change', { bubbles: true }));
          updateQtyButtons();
        }
      });
    }

    // Manual input validation
    qtyInput.addEventListener('change', () => {
      let val = parseInt(qtyInput.value);
      if (isNaN(val) || val < min) val = min;
      if (val > max) val = max;
      qtyInput.value = val;
      updateQtyButtons();
    });

    // Initialize button states
    updateQtyButtons();
  }


  /* =========================================================================
   * 4. ACCORDION — info sections toggle (mobile)
   * Desktop: all sections forced open via CSS
   * Mobile: click toggle opens/closes sections
   * ========================================================================= */
  const sectionToggles = document.querySelectorAll('.product-section__toggle');

  sectionToggles.forEach(toggle => {
    toggle.addEventListener('click', () => {
      // Only toggle on mobile (< 992px)
      if (window.innerWidth >= 992) return;

      const expanded = toggle.getAttribute('aria-expanded') === 'true';
      const bodyId = toggle.getAttribute('aria-controls');
      const body = document.getElementById(bodyId);

      if (body) {
        if (expanded) {
          toggle.setAttribute('aria-expanded', 'false');
          body.hidden = true;
        } else {
          toggle.setAttribute('aria-expanded', 'true');
          body.hidden = false;
        }
      }
    });
  });


  /* =========================================================================
   * 5. STICKY BOTTOM BAR — IntersectionObserver
   * Shows when the main CTA button scrolls out of viewport
   * ========================================================================= */
  const stickyBar = document.getElementById('js-product-sticky-bar');
  const mainCTA = document.querySelector('.product-cta__btn');

  if (stickyBar && mainCTA) {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          // Show sticky bar when main CTA is NOT visible
          stickyBar.classList.toggle('is-visible', !entry.isIntersecting);
        });
      },
      {
        root: null,
        threshold: 0,
        rootMargin: '0px'
      }
    );

    observer.observe(mainCTA);
  }


  /* =========================================================================
   * 6. SHARE — Web Share API with fallback
   * ========================================================================= */
  const shareBtn = document.querySelector('[data-action="share"]');

  if (shareBtn) {
    shareBtn.addEventListener('click', async () => {
      const title = document.getElementById('js-product-title')?.textContent?.trim() || document.title;
      const url = window.location.href;

      if (navigator.share) {
        try {
          await navigator.share({ title, url });
        } catch (err) {
          // User cancelled — do nothing
          if (err.name !== 'AbortError') {
            console.warn('Share failed:', err);
          }
        }
      } else {
        // Fallback: copy URL to clipboard
        try {
          await navigator.clipboard.writeText(url);
          // Simple visual feedback
          const originalHTML = shareBtn.innerHTML;
          shareBtn.innerHTML = '<i class="fa-solid fa-check me-1" aria-hidden="true"></i> Скопійовано';
          setTimeout(() => {
            shareBtn.innerHTML = originalHTML;
          }, 2000);
        } catch (err) {
          console.warn('Clipboard write failed:', err);
        }
      }
    });
  }

});
