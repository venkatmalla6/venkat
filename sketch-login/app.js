/**
 * Main Application Logic
 * Pencil Sketch Interactive Login Experience
 */

document.addEventListener('DOMContentLoaded', () => {
  // DOM Elements
  const body = document.body;
  const switchPlate = document.getElementById('switchPlate');
  const lightBeam = document.querySelector('.light-beam');
  const characterArena = document.getElementById('characterArena');
  const characterBubble = document.getElementById('characterBubble');
  const bubbleText = document.getElementById('bubbleText');
  const replayIntroBtn = document.getElementById('replayIntroBtn');
  const soundToggle = document.getElementById('soundToggle');
  
  // Character Anatomy Elements
  const armLDefault = document.getElementById('armLDefault');
  const armLReach = document.getElementById('armLReach');
  const handLReach = document.getElementById('handLReach');
  const armRDefault = document.getElementById('armRDefault');
  const handRThumbsUp = document.getElementById('handRThumbsUp');
  const handsCoverEyes = document.getElementById('handsCoverEyes');
  const charEyes = document.getElementById('charEyes');
  const charMouth = document.getElementById('charMouth');
  
  // Theme Switching Buttons (White vs Black Card)
  const cardStyleWhite = document.getElementById('cardStyleWhite');
  const cardStyleBlack = document.getElementById('cardStyleBlack');
  const loginCard = document.getElementById('loginCard');
  
  // Form Elements
  const loginForm = document.getElementById('loginForm');
  const emailInput = document.getElementById('emailInput');
  const passwordInput = document.getElementById('passwordInput');
  const togglePasswordBtn = document.getElementById('togglePasswordBtn');
  const quickFillBtn = document.getElementById('quickFillBtn');
  const rememberMeCheckbox = document.getElementById('rememberMeCheckbox');
  const submitBtn = document.getElementById('submitBtn');
  const submitSpinner = document.getElementById('submitSpinner');
  const btnContent = document.querySelector('.btn-content');
  
  // Error Elements & Password Meter
  const emailGroup = document.getElementById('emailGroup');
  const passwordGroup = document.getElementById('passwordGroup');
  const passwordMeter = document.getElementById('passwordMeter');
  const meterBar = document.getElementById('meterBar');
  const meterLabel = document.getElementById('meterLabel');
  
  // Modals
  const successModal = document.getElementById('successModal');
  const modalCloseBtn = document.getElementById('modalCloseBtn');
  const modalUserMsg = document.getElementById('modalUserMsg');
  const forgotPasswordLink = document.getElementById('forgotPasswordLink');
  const forgotModal = document.getElementById('forgotModal');
  const forgotCancelBtn = document.getElementById('forgotCancelBtn');
  const forgotSubmitBtn = document.getElementById('forgotSubmitBtn');
  const forgotEmailInput = document.getElementById('forgotEmailInput');

  // State flags
  let isLightOn = false;
  let isIntroPlaying = false;
  let typingDebounceTimer = null;

  // Sound Engine
  const sound = window.soundEngine;

  /* ==========================================================================
     Character Poses & Speech Management
     ========================================================================== */

  function setCharacterBubble(text, duration = 0) {
    if (bubbleText) {
      bubbleText.innerHTML = text;
      characterBubble.style.opacity = '1';
      characterBubble.style.transform = 'translateX(-40%) scale(1)';
    }

    if (duration > 0) {
      setTimeout(() => {
        if (bubbleText.innerHTML === text) {
          characterBubble.style.opacity = '0.9';
        }
      }, duration);
    }
  }

  function setCharacterPose(pose) {
    // Reset all pose modifications
    armLDefault.classList.remove('hidden');
    armLReach.classList.add('hidden');
    handLReach.classList.add('hidden');
    
    armRDefault.classList.remove('hidden');
    handRThumbsUp.classList.add('hidden');
    handsCoverEyes.classList.add('hidden');

    if (charMouth) {
      charMouth.setAttribute('d', 'M128,124 Q138,133 148,124'); // Normal smile
    }

    switch (pose) {
      case 'reach-switch':
        armLDefault.classList.add('hidden');
        armLReach.classList.remove('hidden');
        handLReach.classList.remove('hidden');
        break;

      case 'cover-eyes':
        handsCoverEyes.classList.remove('hidden');
        armLDefault.classList.add('hidden');
        armRDefault.classList.add('hidden');
        if (charMouth) {
          charMouth.setAttribute('d', 'M130,126 Q138,122 146,126'); // Shy cute smile
        }
        break;

      case 'thumbs-up':
        armRDefault.classList.add('hidden');
        handRThumbsUp.classList.remove('hidden');
        if (charMouth) {
          charMouth.setAttribute('d', 'M126,122 Q138,138 150,122'); // Big happy smile
        }
        break;

      case 'confused':
        if (charMouth) {
          charMouth.setAttribute('d', 'M128,127 Q138,120 148,127'); // Wavy / unsure mouth
        }
        break;

      case 'idle':
      default:
        // Default pose
        break;
    }
  }

  /* ==========================================================================
     Lighting & Switch Mechanics
     ========================================================================== */

  function triggerLightBeam() {
    if (lightBeam) {
      lightBeam.classList.remove('flash');
      // Trigger reflow
      void lightBeam.offsetWidth;
      lightBeam.classList.add('flash');
    }
  }

  function turnLightOn(animateCharacter = false) {
    isLightOn = true;
    body.classList.remove('light-off');
    body.classList.add('light-on');
    
    sound.playSwitchOn();
    triggerLightBeam();

    if (!animateCharacter) {
      setCharacterPose('idle');
      setCharacterBubble("There we go! Canvas is lit ✨", 3500);
    }
  }

  function turnLightOff() {
    isLightOn = false;
    body.classList.remove('light-on');
    body.classList.add('light-off');
    
    sound.playSwitchOff();
    setCharacterPose('confused');
    setCharacterBubble("Who turned off the atelier light? 🔦", 4000);
  }

  function toggleLight() {
    if (isLightOn) {
      turnLightOff();
    } else {
      turnLightOn();
    }
  }

  // Switch Click Event
  switchPlate.addEventListener('click', () => {
    toggleLight();
  });

  /* ==========================================================================
     Cinematic Character Intro Sequence
     (Human sketch steps in, reaches up, flips switch, yellow room illuminates)
     ========================================================================== */

  function playIntroSequence() {
    if (isIntroPlaying) return;
    isIntroPlaying = true;

    // Reset to Dark State
    body.classList.remove('light-on');
    body.classList.add('light-off');
    isLightOn = false;

    // Set initial dialogue
    setCharacterBubble("Hold on, let me turn on the switch for you... 💡");
    setCharacterPose('idle');

    // Reset character positioning & apply walk animation
    characterArena.classList.remove('walking-intro');
    void characterArena.offsetWidth;
    characterArena.classList.add('walking-intro');

    // Step 1: Character walks in towards switch
    setTimeout(() => {
      // Step 2: Character raises arm to reach the switch
      setCharacterPose('reach-switch');
      setCharacterBubble("Just a second... *click*");
    }, 1100);

    // Step 3: Finger clicks the switch!
    setTimeout(() => {
      turnLightOn(true);
      setCharacterBubble("Voila! Welcome to the atelier ✨");
    }, 1500);

    // Step 4: Character lowers arm and settles into position beside login card
    setTimeout(() => {
      setCharacterPose('idle');
      characterArena.classList.remove('walking-intro');
      isIntroPlaying = false;
      
      // Auto focus email input for immediate readiness
      setTimeout(() => {
        emailInput.focus();
      }, 400);
    }, 2400);
  }

  // Replay Intro Button
  replayIntroBtn.addEventListener('click', () => {
    sound.playButtonClick();
    playIntroSequence();
  });

  /* ==========================================================================
     Card Theme Switcher (White Paper Card vs Ink Black Card)
     ========================================================================== */

  function setCardStyle(style) {
    sound.playButtonClick();
    if (style === 'white') {
      loginCard.classList.remove('theme-black');
      loginCard.classList.add('theme-white');
      cardStyleWhite.classList.add('active');
      cardStyleBlack.classList.remove('active');
      setCharacterBubble("White paper card selected 📜");
    } else {
      loginCard.classList.remove('theme-white');
      loginCard.classList.add('theme-black');
      cardStyleBlack.classList.add('active');
      cardStyleWhite.classList.remove('active');
      setCharacterBubble("Black ink card selected 🖋️");
    }
  }

  cardStyleWhite.addEventListener('click', () => setCardStyle('white'));
  cardStyleBlack.addEventListener('click', () => setCardStyle('black'));

  /* ==========================================================================
     Sound Toggle
     ========================================================================== */

  const soundOnIcon = document.querySelector('.sound-on-icon');
  const soundOffIcon = document.querySelector('.sound-off-icon');
  const soundText = soundToggle.querySelector('.btn-text');

  soundToggle.addEventListener('click', () => {
    const isNowOn = sound.toggleSound();
    if (isNowOn) {
      soundOnIcon.classList.remove('hidden');
      soundOffIcon.classList.add('hidden');
      soundText.textContent = 'Sound ON';
      sound.playButtonClick();
      setCharacterBubble("Sound effects enabled! 🎵");
    } else {
      soundOnIcon.classList.add('hidden');
      soundOffIcon.classList.remove('hidden');
      soundText.textContent = 'Sound OFF';
    }
  });

  /* ==========================================================================
     Input Micro-Interactions & Character Reactions
     ========================================================================== */

  // Email Focus Interactions
  emailInput.addEventListener('focus', () => {
    emailGroup.classList.add('focused');
    if (!passwordInput.matches(':focus')) {
      setCharacterPose('idle');
      setCharacterBubble("What's your artist email? ✏️");
    }
  });

  emailInput.addEventListener('blur', () => {
    emailGroup.classList.remove('focused');
    validateEmail(false);
  });

  // Password Focus Interaction: CHARACTER COVERS EYES! 🙈
  passwordInput.addEventListener('focus', () => {
    passwordGroup.classList.add('focused');
    passwordMeter.classList.add('active');
    
    // Trigger the charming eye cover pose!
    setCharacterPose('cover-eyes');
    setCharacterBubble("I'm looking away! Your secret is safe 🙈");
  });

  passwordInput.addEventListener('blur', () => {
    passwordGroup.classList.remove('focused');
    if (passwordInput.value.length === 0) {
      passwordMeter.classList.remove('active');
    }
    
    // Character removes hands from eyes
    setCharacterPose('idle');
    setCharacterBubble("I won't tell anyone 😉", 2500);
    validatePassword(false);
  });

  // Keystroke sound & dynamic password strength calculation
  function handleTypingScribble() {
    sound.playPencilScribble();
  }

  emailInput.addEventListener('input', () => {
    handleTypingScribble();
    if (emailGroup.classList.contains('has-error')) {
      validateEmail(false);
    }
  });

  passwordInput.addEventListener('input', () => {
    handleTypingScribble();
    updatePasswordStrength(passwordInput.value);
    if (passwordGroup.classList.contains('has-error')) {
      validatePassword(false);
    }
  });

  // Password Strength Meter
  function updatePasswordStrength(val) {
    let score = 0;
    if (!val) {
      meterBar.style.width = '0%';
      meterBar.style.backgroundColor = '#E4E4E7';
      meterLabel.textContent = 'Password strength: Empty';
      return;
    }

    if (val.length >= 6) score += 1;
    if (val.length >= 10) score += 1;
    if (/[A-Z]/.test(val)) score += 1;
    if (/[0-9]/.test(val)) score += 1;
    if (/[^A-Za-z0-9]/.test(val)) score += 1;

    switch (score) {
      case 1:
        meterBar.style.width = '25%';
        meterBar.style.backgroundColor = '#EF4444';
        meterLabel.textContent = 'Strength: Weak sketch ✏️';
        break;
      case 2:
      case 3:
        meterBar.style.width = '60%';
        meterBar.style.backgroundColor = '#F59E0B';
        meterLabel.textContent = 'Strength: Getting solid 📐';
        break;
      case 4:
      case 5:
        meterBar.style.width = '100%';
        meterBar.style.backgroundColor = '#16A34A';
        meterLabel.textContent = 'Strength: Masterpiece lock 🎨!';
        break;
    }
  }

  // Show/Hide Password Toggle
  togglePasswordBtn.addEventListener('click', () => {
    sound.playButtonClick();
    const eyeOpen = togglePasswordBtn.querySelector('.eye-open');
    const eyeClosed = togglePasswordBtn.querySelector('.eye-closed');

    if (passwordInput.type === 'password') {
      passwordInput.type = 'text';
      eyeOpen.classList.add('hidden');
      eyeClosed.classList.remove('hidden');
      setCharacterBubble("Peeking through fingers! 👀");
    } else {
      passwordInput.type = 'password';
      eyeOpen.classList.remove('hidden');
      eyeClosed.classList.add('hidden');
      setCharacterBubble("Hidden again! 🙈");
    }
  });

  // Quick Demo Auto-Fill
  quickFillBtn.addEventListener('click', () => {
    sound.playButtonClick();
    emailInput.value = 'artist@sketch.studio';
    passwordInput.value = 'Palette#2026Master';
    updatePasswordStrength(passwordInput.value);
    passwordMeter.classList.add('active');
    validateEmail(false);
    validatePassword(false);
    setCharacterBubble("Demo draft credentials loaded! 🚀");
  });

  // Remember Me Checkbox Sound
  rememberMeCheckbox.addEventListener('change', () => {
    sound.playButtonClick();
  });

  /* ==========================================================================
     Form Validation & Submission
     ========================================================================== */

  function validateEmail(showError = true) {
    const val = emailInput.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const isValid = emailRegex.test(val);

    if (!isValid && showError) {
      emailGroup.classList.add('has-error');
    } else if (isValid) {
      emailGroup.classList.remove('has-error');
    }
    return isValid;
  }

  function validatePassword(showError = true) {
    const val = passwordInput.value;
    const isValid = val.length >= 6;

    if (!isValid && showError) {
      passwordGroup.classList.add('has-error');
    } else if (isValid) {
      passwordGroup.classList.remove('has-error');
    }
    return isValid;
  }

  loginForm.addEventListener('submit', (e) => {
    e.preventDefault();

    // Ensure light is on if user clicks submit in the dark
    if (!isLightOn) {
      turnLightOn();
    }

    const isEmailValid = validateEmail(true);
    const isPasswordValid = validatePassword(true);

    if (!isEmailValid || !isPasswordValid) {
      sound.playErrorBuzz();
      setCharacterPose('confused');
      setCharacterBubble("Check the draft details, something's missing! ✏️");
      
      // Card subtle shake animation
      loginCard.style.animation = 'shakeCard 0.4s ease';
      setTimeout(() => { loginCard.style.animation = ''; }, 450);
      return;
    }

    // Submission In-Progress State
    sound.playButtonClick();
    submitBtn.disabled = true;
    btnContent.classList.add('hidden');
    submitSpinner.classList.remove('hidden');
    setCharacterBubble("Validating your sketch credentials... ⏳");

    setTimeout(() => {
      // Success State
      submitBtn.disabled = false;
      btnContent.classList.remove('hidden');
      submitSpinner.classList.add('hidden');

      sound.playSuccessChime();
      setCharacterPose('thumbs-up');
      setCharacterBubble("You're in! Welcome to the atelier! 🎉", 5000);

      // Show Success Modal
      modalUserMsg.textContent = `Welcome back, ${emailInput.value}! Your sketch workspace is loaded and ready.`;
      successModal.classList.remove('hidden');
    }, 1200);
  });

  // Close Success Modal
  modalCloseBtn.addEventListener('click', () => {
    sound.playButtonClick();
    successModal.classList.add('hidden');
    setCharacterPose('idle');
  });

  /* ==========================================================================
     Forgot Password Modal
     ========================================================================== */

  forgotPasswordLink.addEventListener('click', (e) => {
    e.preventDefault();
    sound.playButtonClick();
    forgotModal.classList.remove('hidden');
    forgotEmailInput.value = emailInput.value || '';
    forgotEmailInput.focus();
  });

  forgotCancelBtn.addEventListener('click', () => {
    sound.playButtonClick();
    forgotModal.classList.add('hidden');
  });

  forgotSubmitBtn.addEventListener('click', () => {
    const val = forgotEmailInput.value.trim();
    if (!val || !val.includes('@')) {
      sound.playErrorBuzz();
      forgotEmailInput.style.borderColor = '#EF4444';
      return;
    }

    sound.playSuccessChime();
    forgotModal.classList.add('hidden');
    setCharacterBubble("Reset sketch link sent to your inbox! 📬", 4000);
  });

  // Social Auth Handler
  window.handleSocialAuth = function(provider) {
    if (!isLightOn) turnLightOn();
    sound.playButtonClick();
    setCharacterBubble(`Connecting via ${provider}... 🎨`);
    setTimeout(() => {
      sound.playSuccessChime();
      modalUserMsg.textContent = `Authenticated successfully with ${provider}!`;
      successModal.classList.remove('hidden');
      setCharacterPose('thumbs-up');
    }, 800);
  };

  /* ==========================================================================
     Initialize and Start the Experience
     ========================================================================== */

  // Add Card Shake Keyframes dynamically
  const styleSheet = document.createElement('style');
  styleSheet.textContent = `
    @keyframes shakeCard {
      0%, 100% { transform: translateX(0); }
      20% { transform: translateX(-8px); }
      40% { transform: translateX(8px); }
      60% { transform: translateX(-5px); }
      80% { transform: translateX(5px); }
    }
  `;
  document.head.appendChild(styleSheet);

  // Automatically start the cinematic human sketch intro sequence on initial load
  setTimeout(() => {
    playIntroSequence();
  }, 400);

});
