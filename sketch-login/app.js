/**
 * Main Application Logic
 * Pencil Sketch Interactive Login Experience
 * Atelier Studio Edition - Featuring Vector Pupil Tracking, Spring Pull-Cord,
 * Interactive Doodle Board, Multi-Auth, Physics Particles & Audio Synthesizer
 */

document.addEventListener('DOMContentLoaded', () => {
  // Sound Engine
  const sound = window.soundEngine;

  // DOM Elements
  const body = document.body;
  const switchPlate = document.getElementById('switchPlate');
  const lightBeam = document.querySelector('.light-beam');
  const characterArena = document.getElementById('characterArena');
  const characterWrapper = document.getElementById('characterWrapper');
  const characterBubble = document.getElementById('characterBubble');
  const bubbleText = document.getElementById('bubbleText');
  const replayIntroBtn = document.getElementById('replayIntroBtn');
  const soundToggle = document.getElementById('soundToggle');
  const ambientToggle = document.getElementById('ambientToggle');
  const eqIcon = document.getElementById('eqIcon');
  const shortcutsBtn = document.getElementById('shortcutsBtn');
  const shortcutsModal = document.getElementById('shortcutsModal');
  const shortcutsCloseBtn = document.getElementById('shortcutsCloseBtn');
  
  // Pull Cord Elements
  const pullCordStation = document.getElementById('pullCordStation');
  const cordChain = document.getElementById('cordChain');
  const cordHandle = document.getElementById('cordHandle');

  // Character Anatomy Elements
  const pupilGroupL = document.getElementById('pupilGroupL');
  const pupilGroupR = document.getElementById('pupilGroupR');
  const armLDefault = document.getElementById('armLDefault');
  const armLReach = document.getElementById('armLReach');
  const handLReach = document.getElementById('handLReach');
  const armRDefault = document.getElementById('armRDefault');
  const handRThumbsUp = document.getElementById('handRThumbsUp');
  const handsCoverEyes = document.getElementById('handsCoverEyes');
  const charMouth = document.getElementById('charMouth');
  const charBlush = document.getElementById('charBlush');
  const mascotPencil = document.getElementById('mascotPencil');
  
  // Themes & Cards
  const cardStyleWhite = document.getElementById('cardStyleWhite');
  const cardStyleBlack = document.getElementById('cardStyleBlack');
  const loginCard = document.getElementById('loginCard');
  const cardMainTitle = document.getElementById('cardMainTitle');
  const cardMainSubtitle = document.getElementById('cardMainSubtitle');
  const footerPromptText = document.getElementById('footerPromptText');
  const signUpLink = document.getElementById('signUpLink');

  // Auth Tabs & Panes
  const tabSignIn = document.getElementById('tabSignIn');
  const tabSignUp = document.getElementById('tabSignUp');
  const tabPasskey = document.getElementById('tabPasskey');
  const paneSignIn = document.getElementById('paneSignIn');
  const paneSignUp = document.getElementById('paneSignUp');
  const panePasskey = document.getElementById('panePasskey');

  // Form Elements (Sign In)
  const loginForm = document.getElementById('loginForm');
  const emailInput = document.getElementById('emailInput');
  const passwordInput = document.getElementById('passwordInput');
  const togglePasswordBtn = document.getElementById('togglePasswordBtn');
  const quickFillBtn = document.getElementById('quickFillBtn');
  const rememberMeCheckbox = document.getElementById('rememberMeCheckbox');
  const submitBtn = document.getElementById('submitBtn');
  const submitSpinner = document.getElementById('submitSpinner');
  const btnContent = document.querySelector('.btn-content');
  const emailGroup = document.getElementById('emailGroup');
  const passwordGroup = document.getElementById('passwordGroup');
  const passwordMeter = document.getElementById('passwordMeter');
  const meterBar = document.getElementById('meterBar');
  const meterLabel = document.getElementById('meterLabel');

  // Form Elements (Sign Up)
  const signUpForm = document.getElementById('signUpForm');
  const avatarChoices = document.querySelectorAll('.avatar-choice');
  const regNameInput = document.getElementById('regNameInput');
  const regEmailInput = document.getElementById('regEmailInput');
  const regPassInput = document.getElementById('regPassInput');
  const svgArtworkProgress = document.getElementById('svgArtworkProgress');
  const artQualityTitle = document.getElementById('artQualityTitle');
  const artQualitySub = document.getElementById('artQualitySub');

  // Form Elements (Passkey OTP)
  const passkeyForm = document.getElementById('passkeyForm');
  const otpBoxes = document.querySelectorAll('.otp-box');
  const otpCountdown = document.getElementById('otpCountdown');
  const otpResendBtn = document.getElementById('otpResendBtn');

  // Modals
  const successModal = document.getElementById('successModal');
  const modalCloseBtn = document.getElementById('modalCloseBtn');
  const modalUserMsg = document.getElementById('modalUserMsg');
  const forgotPasswordLink = document.getElementById('forgotPasswordLink');
  const forgotModal = document.getElementById('forgotModal');
  const forgotCancelBtn = document.getElementById('forgotCancelBtn');
  const forgotSubmitBtn = document.getElementById('forgotSubmitBtn');
  const forgotEmailInput = document.getElementById('forgotEmailInput');

  // Desk Props
  const coffeeProp = document.getElementById('coffeeProp');
  const caffeineBadge = document.getElementById('caffeineBadge');
  const paperPlaneProp = document.getElementById('paperPlaneProp');
  const stickyNoteProp = document.getElementById('stickyNoteProp');
  const stickyTipText = document.getElementById('stickyTipText');

  // Doodle Mode Elements
  const doodleModeBtn = document.getElementById('doodleModeBtn');
  const doodleCanvas = document.getElementById('doodleCanvas');
  const doodleToolbar = document.getElementById('doodleToolbar');
  const toolBtns = document.querySelectorAll('.doodle-tool-btn[data-tool]');
  const swatches = document.querySelectorAll('.swatch');
  const sizeDots = document.querySelectorAll('.size-dot');
  const doodleUndoBtn = document.getElementById('doodleUndoBtn');
  const doodleClearBtn = document.getElementById('doodleClearBtn');
  const doodleDownloadBtn = document.getElementById('doodleDownloadBtn');
  const doodleCloseBtn = document.getElementById('doodleCloseBtn');

  // State variables
  let isLightOn = false;
  let isIntroPlaying = false;
  let currentAuthTab = 'signin';
  let caffeineLevel = 100;
  let isCoveringEyes = false;

  /* ==========================================================================
     Character Speech & Expressions
     ========================================================================== */

  const artistQuotes = [
    "Every masterpiece begins with a single graphite draft! ✏️",
    "Don't smudge my lines, I just had my outline sharpened! 📐",
    "Fun fact: 90% of art is pressing Ctrl+Z until it looks intentional! 🎨",
    "Looking sharp today! Ready to unlock your workspace? 🚀",
    "I was drawn with a 2B pencil and excessive enthusiasm! ✨",
    "I'm keeping an eye on your craft... literally! 👀",
    "Art is where freedom meets graphite dust! 🌟",
    "Need coffee? Check out the steaming mug down there! ☕",
    "Pro tip: Try pressing 'D' to unlock Doodle Mode! 🖌️",
    "Secret shortcuts: 'L' toggles light, 'T' toggles ink! 💡"
  ];

  const designWisdom = [
    '"Every masterpiece begins with a simple sketch." ✏️',
    '"Simplicity is the ultimate sophistication." — Leonardo 📐',
    '"Color is the keyboard, the eyes are the harmonies." 🎨',
    '"Creativity takes courage." — Henri Matisse 🌟',
    '"Design is thinking made visual." — Saul Bass ☕',
    '"Good design is as little design as possible." — Rams 🖋️'
  ];

  function setCharacterBubble(text, duration = 0) {
    if (bubbleText) {
      bubbleText.innerHTML = text;
      characterBubble.style.opacity = '1';
      characterBubble.style.transform = 'translateX(-40%) scale(1)';
    }
    if (duration > 0) {
      setTimeout(() => {
        if (bubbleText && bubbleText.innerHTML === text) {
          characterBubble.style.opacity = '0.9';
        }
      }, duration);
    }
  }

  function setCharacterPose(pose) {
    armLDefault.classList.remove('hidden');
    armLReach.classList.add('hidden');
    handLReach.classList.add('hidden');
    armRDefault.classList.remove('hidden');
    handRThumbsUp.classList.add('hidden');
    handsCoverEyes.classList.add('hidden');
    isCoveringEyes = false;

    if (charMouth) charMouth.setAttribute('d', 'M128,124 Q138,133 148,124');
    if (charBlush) charBlush.style.opacity = '0.4';

    switch (pose) {
      case 'reach-switch':
        armLDefault.classList.add('hidden');
        armLReach.classList.remove('hidden');
        handLReach.classList.remove('hidden');
        break;
      case 'cover-eyes':
        isCoveringEyes = true;
        handsCoverEyes.classList.remove('hidden');
        armLDefault.classList.add('hidden');
        armRDefault.classList.add('hidden');
        if (charMouth) charMouth.setAttribute('d', 'M130,126 Q138,122 146,126');
        break;
      case 'thumbs-up':
        armRDefault.classList.add('hidden');
        handRThumbsUp.classList.remove('hidden');
        if (charMouth) charMouth.setAttribute('d', 'M126,122 Q138,138 150,122');
        if (charBlush) charBlush.style.opacity = '0.8';
        break;
      case 'confused':
        if (charMouth) charMouth.setAttribute('d', 'M128,127 Q138,120 148,127');
        break;
      case 'giggle':
        if (charMouth) charMouth.setAttribute('d', 'M126,120 Q138,140 150,120');
        if (charBlush) charBlush.style.opacity = '1';
        break;
    }
  }

  /* ==========================================================================
     Real-Time Vector Pupil Gaze Tracking
     ========================================================================== */

  let lastMouseX = window.innerWidth / 2;
  let lastMouseY = window.innerHeight / 2;
  let mouseVelocity = 0;
  let lastTime = Date.now();

  function updatePupils(targetX, targetY) {
    if (isCoveringEyes || !pupilGroupL || !pupilGroupR) return;

    const charRect = characterWrapper.getBoundingClientRect();
    const eyeCenterLX = charRect.left + (charRect.width * (123 / 280));
    const eyeCenterLY = charRect.top + (charRect.height * (98 / 440));
    const eyeCenterRX = charRect.left + (charRect.width * (153 / 280));
    const eyeCenterRY = charRect.top + (charRect.height * (98 / 440));

    // Left Pupil Vector
    const angleL = Math.atan2(targetY - eyeCenterLY, targetX - eyeCenterLX);
    const distL = Math.min(3.8, Math.hypot(targetX - eyeCenterLX, targetY - eyeCenterLY) / 50);
    const dxL = Math.cos(angleL) * distL;
    const dyL = Math.sin(angleL) * distL;
    pupilGroupL.setAttribute('transform', `translate(${dxL.toFixed(2)}, ${dyL.toFixed(2)})`);

    // Right Pupil Vector
    const angleR = Math.atan2(targetY - eyeCenterRY, targetX - eyeCenterRX);
    const distR = Math.min(3.8, Math.hypot(targetX - eyeCenterRX, targetY - eyeCenterRY) / 50);
    const dxR = Math.cos(angleR) * distR;
    const dyR = Math.sin(angleR) * distR;
    pupilGroupR.setAttribute('transform', `translate(${dxR.toFixed(2)}, ${dyR.toFixed(2)})`);
  }

  window.addEventListener('mousemove', (e) => {
    const now = Date.now();
    const dt = Math.max(1, now - lastTime);
    const dist = Math.hypot(e.clientX - lastMouseX, e.clientY - lastMouseY);
    mouseVelocity = dist / dt;
    lastMouseX = e.clientX;
    lastMouseY = e.clientY;
    lastTime = now;

    if (mouseVelocity > 3.2 && !isIntroPlaying) {
      if (charMouth) charMouth.setAttribute('d', 'M130,128 Q138,136 146,128');
    }

    updatePupils(e.clientX, e.clientY);
  });

  // Mascot Interactivity (Poke / Giggle / Spin)
  characterWrapper.addEventListener('click', (e) => {
    sound.playGiggle();
    setCharacterPose('giggle');
    characterArena.classList.remove('char-giggle');
    void characterArena.offsetWidth;
    characterArena.classList.add('char-giggle');
    const randomQuote = artistQuotes[Math.floor(Math.random() * artistQuotes.length)];
    setCharacterBubble(randomQuote, 4000);
    spawnGraphiteSparks(e.clientX, e.clientY, 8);
    setTimeout(() => {
      if (!isCoveringEyes) setCharacterPose('idle');
    }, 1200);
  });

  characterWrapper.addEventListener('dblclick', (e) => {
    sound.playSpinWhoosh();
    characterArena.classList.remove('char-spin');
    void characterArena.offsetWidth;
    characterArena.classList.add('char-spin');
    setCharacterBubble("Whoosh! 360 sketch flip! 🌪️", 3000);
    spawnGraphiteSparks(e.clientX, e.clientY, 20);
    setTimeout(() => {
      characterArena.classList.remove('char-spin');
      setCharacterPose('thumbs-up');
    }, 700);
  });

  // Pencil in pocket trigger
  mascotPencil.addEventListener('click', (e) => {
    e.stopPropagation();
    sound.playButtonClick();
    toggleDoodleMode(true);
    setCharacterBubble("You grabbed my favorite 2B pencil! Start drawing! ✏️", 4000);
  });

  /* ==========================================================================
     Light & Switch Mechanics (Plate & Pull Cord)
     ========================================================================== */

  function triggerLightBeam() {
    if (lightBeam) {
      lightBeam.classList.remove('flash');
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
    spawnGraphiteSparks(120, 140, 16);

    if (!animateCharacter) {
      setCharacterPose('idle');
      setCharacterBubble("There we go! Atelier canvas is lit ✨", 3500);
    }
  }

  function turnLightOff() {
    isLightOn = false;
    body.classList.remove('light-on');
    body.classList.add('light-off');
    sound.playSwitchOff();
    setCharacterPose('confused');
    setCharacterBubble("Who turned off the atelier lamp? 🔦", 4000);
  }

  function toggleLight() {
    if (isLightOn) turnLightOff();
    else turnLightOn();
  }

  switchPlate.addEventListener('click', toggleLight);

  // Pull Cord Spring Drag Physics
  let isDraggingCord = false;
  let cordStartY = 0;
  let cordDisplacement = 0;

  function onCordStart(e) {
    isDraggingCord = true;
    cordStartY = e.clientY || (e.touches && e.touches[0].clientY);
    cordChain.style.transition = 'none';
  }

  function onCordMove(e) {
    if (!isDraggingCord) return;
    const clientY = e.clientY || (e.touches && e.touches[0].clientY);
    cordDisplacement = Math.max(0, Math.min(70, (clientY - cordStartY) * 0.8));
    cordChain.style.transform = `translateY(${cordDisplacement}px) scaleY(${1 + cordDisplacement / 150})`;
  }

  function onCordEnd() {
    if (!isDraggingCord) return;
    isDraggingCord = false;
    cordChain.style.transition = 'transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.4)';
    cordChain.style.transform = 'translateY(0) scaleY(1)';

    if (cordDisplacement > 15) {
      sound.playPullCordSnap();
      toggleLight();
    }
    cordDisplacement = 0;
  }

  pullCordStation.addEventListener('mousedown', onCordStart);
  window.addEventListener('mousemove', onCordMove);
  window.addEventListener('mouseup', onCordEnd);
  pullCordStation.addEventListener('touchstart', onCordStart, { passive: true });
  window.addEventListener('touchmove', onCordMove, { passive: true });
  window.addEventListener('touchend', onCordEnd);

  /* ==========================================================================
     Intro Sequence
     ========================================================================== */

  function playIntroSequence() {
    if (isIntroPlaying) return;
    isIntroPlaying = true;

    body.classList.remove('light-on');
    body.classList.add('light-off');
    isLightOn = false;

    setCharacterBubble("Hold on, let me turn on the studio light... 💡");
    setCharacterPose('idle');

    characterArena.classList.remove('walking-intro');
    void characterArena.offsetWidth;
    characterArena.classList.add('walking-intro');

    setTimeout(() => {
      setCharacterPose('reach-switch');
      setCharacterBubble("Just a second... *click*");
    }, 1100);

    setTimeout(() => {
      turnLightOn(true);
      setCharacterBubble("Voila! Welcome to the Atelier Studio ✨");
    }, 1500);

    setTimeout(() => {
      setCharacterPose('idle');
      characterArena.classList.remove('walking-intro');
      isIntroPlaying = false;
      setTimeout(() => { if (emailInput) emailInput.focus(); }, 400);
    }, 2400);
  }

  replayIntroBtn.addEventListener('click', () => {
    sound.playButtonClick();
    playIntroSequence();
  });

  /* ==========================================================================
     Card Theme & Studio Atmosphere Switching
     ========================================================================== */

  function setCardStyle(style) {
    sound.playButtonClick();
    if (style === 'white') {
      loginCard.classList.remove('theme-black');
      loginCard.classList.add('theme-white');
      cardStyleWhite.classList.add('active');
      cardStyleBlack.classList.remove('active');
      setCharacterBubble("Paper white canvas selected 📜");
    } else {
      loginCard.classList.remove('theme-white');
      loginCard.classList.add('theme-black');
      cardStyleBlack.classList.add('active');
      cardStyleWhite.classList.remove('active');
      setCharacterBubble("Velvet black ink card selected 🖋️");
    }
  }

  cardStyleWhite.addEventListener('click', () => setCardStyle('white'));
  cardStyleBlack.addEventListener('click', () => setCardStyle('black'));

  // Atmosphere Palette Dots
  const palDots = document.querySelectorAll('.pal-dot');
  palDots.forEach(dot => {
    dot.addEventListener('click', () => {
      sound.playButtonClick();
      palDots.forEach(d => d.classList.remove('active'));
      dot.classList.add('active');
      const themeClass = dot.dataset.theme;
      body.classList.remove('theme-amber', 'theme-terracotta', 'theme-celadon', 'theme-blueprint');
      body.classList.add(themeClass);
      if (!isLightOn) turnLightOn();
      setCharacterBubble(`Atmosphere set to ${dot.title}! 🎨`, 3000);
    });
  });

  /* ==========================================================================
     Audio & ASMR Ambient Controls
     ========================================================================== */

  const soundOnIcon = document.querySelector('.sound-on-icon');
  const soundOffIcon = document.querySelector('.sound-off-icon');

  soundToggle.addEventListener('click', () => {
    const isNowOn = sound.toggleSound();
    if (isNowOn) {
      soundOnIcon.classList.remove('hidden');
      soundOffIcon.classList.add('hidden');
      sound.playButtonClick();
      setCharacterBubble("Audio sound effects enabled! 🎵");
    } else {
      soundOnIcon.classList.add('hidden');
      soundOffIcon.classList.remove('hidden');
    }
  });

  ambientToggle.addEventListener('click', () => {
    sound.init();
    const isRunning = sound.toggleAmbient();
    if (isRunning) {
      ambientToggle.classList.add('btn-active');
      eqIcon.classList.add('playing');
      setCharacterBubble("Playing Lo-Fi Atelier vinyl & chords ☕🎧", 3500);
    } else {
      ambientToggle.classList.remove('btn-active');
      eqIcon.classList.remove('playing');
      setCharacterBubble("Ambient music paused 🔇", 2500);
    }
  });

  /* ==========================================================================
     Multi-Tab Auth Switching (Sign In / Register / Passkey PIN)
     ========================================================================== */

  function switchAuthTab(tab) {
    sound.playPaperFlip();
    currentAuthTab = tab;

    [tabSignIn, tabSignUp, tabPasskey].forEach(t => t.classList.remove('active'));
    [paneSignIn, paneSignUp, panePasskey].forEach(p => p.classList.add('hidden'));

    if (tab === 'signin') {
      tabSignIn.classList.add('active');
      paneSignIn.classList.remove('hidden');
      cardMainTitle.textContent = "Welcome Back";
      cardMainSubtitle.innerHTML = 'Sign in to your creative atelier.<svg class="subtitle-flourish" viewBox="0 0 120 12" width="120" height="12"><path d="M2,6 Q30,1 60,7 Q90,12 118,5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>';
      footerPromptText.textContent = "Don't have a draft book?";
      signUpLink.textContent = "Create an account";
      setCharacterBubble("Welcome back, artist! ✏️");
    } else if (tab === 'signup') {
      tabSignUp.classList.add('active');
      paneSignUp.classList.remove('hidden');
      cardMainTitle.textContent = "Join Atelier";
      cardMainSubtitle.innerHTML = 'Craft your creative passport.<svg class="subtitle-flourish" viewBox="0 0 120 12" width="120" height="12"><path d="M2,6 Q30,1 60,7 Q90,12 118,5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>';
      footerPromptText.textContent = "Already have an atelier key?";
      signUpLink.textContent = "Sign in instead";
      setCharacterBubble("New artist! Pick your persona! 🎨");
    } else if (tab === 'passkey') {
      tabPasskey.classList.add('active');
      panePasskey.classList.remove('hidden');
      cardMainTitle.textContent = "Passkey Studio PIN";
      cardMainSubtitle.innerHTML = 'Enter your 6-digit sketch code.<svg class="subtitle-flourish" viewBox="0 0 120 12" width="120" height="12"><path d="M2,6 Q30,1 60,7 Q90,12 118,5" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>';
      footerPromptText.textContent = "Want traditional password?";
      signUpLink.textContent = "Sign in with password";
      setCharacterBubble("Enter your 6-digit studio code! 🔑");
      if (otpBoxes[0]) setTimeout(() => otpBoxes[0].focus(), 150);
    }
  }

  tabSignIn.addEventListener('click', () => switchAuthTab('signin'));
  tabSignUp.addEventListener('click', () => switchAuthTab('signup'));
  tabPasskey.addEventListener('click', () => switchAuthTab('passkey'));
  signUpLink.addEventListener('click', (e) => {
    e.preventDefault();
    if (currentAuthTab === 'signin') switchAuthTab('signup');
    else switchAuthTab('signin');
  });

  // Avatar Selection (Sign Up)
  avatarChoices.forEach(choice => {
    choice.addEventListener('click', () => {
      sound.playStamp();
      avatarChoices.forEach(c => c.classList.remove('selected'));
      choice.classList.add('selected');
      const role = choice.dataset.role;
      const emoji = choice.dataset.avatar;
      setCharacterBubble(`${emoji} Excellent! An esteemed ${role} joins our studio!`, 3000);
      spawnGraphiteSparks(choice.getBoundingClientRect().left + 20, choice.getBoundingClientRect().top + 20, 6);
    });
  });

  // Dynamic SVG Artwork Password Progress (Sign Up)
  regPassInput.addEventListener('input', () => {
    sound.playPencilScribble();
    const val = regPassInput.value;
    let score = 0;
    if (val.length >= 6) score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    if (score <= 1) {
      svgArtworkProgress.setAttribute('d', 'M12 24 L20 14 L28 24 Z');
      svgArtworkProgress.setAttribute('fill', 'none');
      artQualityTitle.textContent = "Draft Wireframe ✏️";
      artQualitySub.textContent = "Add uppercase, numbers & symbols";
    } else if (score <= 3) {
      svgArtworkProgress.setAttribute('d', 'M12 26 L20 10 L28 26 L12 26 M16 20 L24 20');
      svgArtworkProgress.setAttribute('fill', '#FEF08A');
      artQualityTitle.textContent = "Clean Inked Lines 📐";
      artQualitySub.textContent = "Looking solid! Almost a master key.";
    } else {
      svgArtworkProgress.setAttribute('d', 'M20 6 L24 15 L34 16 L26 23 L28 33 L20 28 L12 33 L14 23 L6 16 L16 15 Z');
      svgArtworkProgress.setAttribute('fill', '#10B981');
      artQualityTitle.textContent = "Masterpiece Key 🎨✨";
      artQualitySub.textContent = "Impervious cryptographic art!";
    }
  });

  // 6-Digit OTP Box Handlers
  otpBoxes.forEach((box, idx) => {
    box.addEventListener('input', (e) => {
      sound.playPencilScribble();
      const val = e.target.value;
      if (val && idx < otpBoxes.length - 1) {
        otpBoxes[idx + 1].focus();
      }
    });

    box.addEventListener('keydown', (e) => {
      if (e.key === 'Backspace' && !box.value && idx > 0) {
        otpBoxes[idx - 1].focus();
      }
    });

    box.addEventListener('paste', (e) => {
      e.preventDefault();
      const pasteData = (e.clipboardData || window.clipboardData).getData('text').trim();
      if (/^\d+$/.test(pasteData)) {
        pasteData.split('').slice(0, 6).forEach((char, i) => {
          if (otpBoxes[i]) otpBoxes[i].value = char;
        });
        if (otpBoxes[Math.min(5, pasteData.length)]) {
          otpBoxes[Math.min(5, pasteData.length)].focus();
        }
        sound.playSuccessChime();
      }
    });
  });

  // OTP Resend Countdown
  let otpSeconds = 45;
  const otpTimer = setInterval(() => {
    if (otpSeconds > 0) {
      otpSeconds--;
      otpCountdown.textContent = `00:${otpSeconds < 10 ? '0' : ''}${otpSeconds}`;
    } else {
      otpResendBtn.disabled = false;
      otpResendBtn.style.color = '#18181B';
      otpResendBtn.style.fontWeight = '700';
    }
  }, 1000);

  otpResendBtn.addEventListener('click', () => {
    sound.playButtonClick();
    otpSeconds = 45;
    otpResendBtn.disabled = true;
    otpResendBtn.style.color = '';
    setCharacterBubble("New 6-digit sketch code dispatched! 📬", 3000);
  });

  /* ==========================================================================
     Sign In Form & Validation
     ========================================================================== */

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

  passwordInput.addEventListener('focus', () => {
    passwordGroup.classList.add('focused');
    passwordMeter.classList.add('active');
    setCharacterPose('cover-eyes');
    setCharacterBubble("I'm looking away! Your secret is safe 🙈");
  });

  passwordInput.addEventListener('blur', () => {
    passwordGroup.classList.remove('focused');
    if (passwordInput.value.length === 0) passwordMeter.classList.remove('active');
    setCharacterPose('idle');
    setCharacterBubble("I won't tell anyone 😉", 2500);
    validatePassword(false);
  });

  emailInput.addEventListener('input', () => {
    sound.playPencilScribble();
    if (emailGroup.classList.contains('has-error')) validateEmail(false);
  });

  passwordInput.addEventListener('input', () => {
    sound.playPencilScribble();
    updatePasswordStrength(passwordInput.value);
    if (passwordGroup.classList.contains('has-error')) validatePassword(false);
  });

  function updatePasswordStrength(val) {
    let score = 0;
    if (!val) {
      meterBar.style.width = '0%';
      meterBar.style.backgroundColor = '#E4E4E7';
      meterLabel.textContent = 'Password strength: Empty';
      return;
    }
    if (val.length >= 6) score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

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

  function validateEmail(showError = true) {
    const val = emailInput.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const isValid = emailRegex.test(val);
    if (!isValid && showError) emailGroup.classList.add('has-error');
    else if (isValid) emailGroup.classList.remove('has-error');
    return isValid;
  }

  function validatePassword(showError = true) {
    const val = passwordInput.value;
    const isValid = val.length >= 6;
    if (!isValid && showError) passwordGroup.classList.add('has-error');
    else if (isValid) passwordGroup.classList.remove('has-error');
    return isValid;
  }

  // Form Submissions
  loginForm.addEventListener('submit', (e) => {
    e.preventDefault();
    if (!isLightOn) turnLightOn();
    const isEmailValid = validateEmail(true);
    const isPasswordValid = validatePassword(true);

    if (!isEmailValid || !isPasswordValid) {
      sound.playErrorBuzz();
      setCharacterPose('confused');
      setCharacterBubble("Check the draft details, something's missing! ✏️");
      loginCard.style.animation = 'shakeCard 0.4s ease';
      setTimeout(() => { loginCard.style.animation = ''; }, 450);
      return;
    }

    sound.playButtonClick();
    submitBtn.disabled = true;
    btnContent.classList.add('hidden');
    submitSpinner.classList.remove('hidden');
    setCharacterBubble("Validating your sketch credentials... ⏳");

    setTimeout(() => {
      submitBtn.disabled = false;
      btnContent.classList.remove('hidden');
      submitSpinner.classList.add('hidden');
      sound.playSuccessChime();
      setCharacterPose('thumbs-up');
      setCharacterBubble("You're in! Welcome to the atelier! 🎉", 5000);
      modalUserMsg.textContent = `Welcome back, ${emailInput.value}! Your sketch workspace is loaded and ready.`;
      successModal.classList.remove('hidden');
      spawnConfettiCannon();
    }, 1200);
  });

  signUpForm.addEventListener('submit', (e) => {
    e.preventDefault();
    sound.playButtonClick();
    const name = regNameInput.value || 'Artist';
    sound.playSuccessChime();
    modalUserMsg.textContent = `Artist Pass created for @${name}! Welcome to the Atelier Guild!`;
    successModal.classList.remove('hidden');
    spawnConfettiCannon();
    setCharacterPose('thumbs-up');
  });

  passkeyForm.addEventListener('submit', (e) => {
    e.preventDefault();
    sound.playSuccessChime();
    modalUserMsg.textContent = "Passkey verified successfully! Studio access granted.";
    successModal.classList.remove('hidden');
    spawnConfettiCannon();
    setCharacterPose('thumbs-up');
  });

  modalCloseBtn.addEventListener('click', () => {
    sound.playButtonClick();
    successModal.classList.add('hidden');
    setCharacterPose('idle');
  });

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

  window.handleSocialAuth = function(provider) {
    if (!isLightOn) turnLightOn();
    sound.playButtonClick();
    setCharacterBubble(`Connecting via ${provider}... 🎨`);
    setTimeout(() => {
      sound.playSuccessChime();
      modalUserMsg.textContent = `Authenticated successfully with ${provider}!`;
      successModal.classList.remove('hidden');
      spawnConfettiCannon();
      setCharacterPose('thumbs-up');
    }, 800);
  };

  /* ==========================================================================
     Desk Art Props (Coffee, Airplane, Sticky Note)
     ========================================================================== */

  coffeeProp.addEventListener('click', () => {
    sound.playCoffeeSip();
    caffeineLevel += 25;
    if (caffeineLevel > 200) caffeineLevel = 100;
    caffeineBadge.textContent = `Caffeine: ${caffeineLevel}% ☕`;
    coffeeProp.style.transform = 'scale(1.2) rotate(5deg)';
    setTimeout(() => { coffeeProp.style.transform = ''; }, 250);
    setCharacterBubble("Mmm! Fresh atelier brew! Caffeine boost activated! ⚡", 3500);
  });

  paperPlaneProp.addEventListener('click', () => {
    sound.playAirplaneWhoosh();
    paperPlaneProp.classList.add('flying');
    setCharacterBubble("Paper airplane away! Soaring through the studio! ✈️", 3000);
    setTimeout(() => {
      paperPlaneProp.classList.remove('flying');
    }, 2500);
  });

  stickyNoteProp.addEventListener('click', () => {
    sound.playPaperFlip();
    const randomQuote = designWisdom[Math.floor(Math.random() * designWisdom.length)];
    stickyTipText.textContent = randomQuote;
    stickyNoteProp.style.transform = 'scale(1.1) rotate(2deg)';
    setTimeout(() => { stickyNoteProp.style.transform = ''; }, 300);
    setCharacterBubble("Wisdom note flipped! 💡", 2500);
  });

  /* ==========================================================================
     Live Doodle Board & Canvas Engine
     ========================================================================== */

  const ctx = doodleCanvas.getContext('2d');
  let isDoodling = false;
  let currentTool = 'pencil';
  let currentColor = '#1C1917';
  let currentSize = 7;
  let undoHistory = [];
  const MAX_HISTORY = 15;

  function resizeCanvases() {
    doodleCanvas.width = window.innerWidth * window.devicePixelRatio;
    doodleCanvas.height = window.innerHeight * window.devicePixelRatio;
    doodleCanvas.style.width = window.innerWidth + 'px';
    doodleCanvas.style.height = window.innerHeight + 'px';
    ctx.scale(window.devicePixelRatio, window.devicePixelRatio);

    const fxCanvas = document.getElementById('fxCanvas');
    fxCanvas.width = window.innerWidth;
    fxCanvas.height = window.innerHeight;
  }
  window.addEventListener('resize', resizeCanvases);
  resizeCanvases();

  function saveDoodleState() {
    if (undoHistory.length >= MAX_HISTORY) undoHistory.shift();
    undoHistory.push(ctx.getImageData(0, 0, doodleCanvas.width, doodleCanvas.height));
  }

  function toggleDoodleMode(forceState) {
    sound.playButtonClick();
    const willBeActive = typeof forceState === 'boolean' ? forceState : !body.classList.contains('doodle-active');
    if (willBeActive) {
      body.classList.add('doodle-active');
      doodleModeBtn.classList.add('btn-active');
      setCharacterBubble("Doodle Canvas unlocked! Draw anywhere on screen! 🎨", 4000);
    } else {
      body.classList.remove('doodle-active');
      doodleModeBtn.classList.remove('btn-active');
      setCharacterBubble("Exited Doodle Mode ✏️", 2500);
    }
  }

  doodleModeBtn.addEventListener('click', () => toggleDoodleMode());
  doodleCloseBtn.addEventListener('click', () => toggleDoodleMode(false));

  toolBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      sound.playButtonClick();
      toolBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      currentTool = btn.dataset.tool;
    });
  });

  swatches.forEach(swatch => {
    swatch.addEventListener('click', () => {
      sound.playButtonClick();
      swatches.forEach(s => s.classList.remove('active'));
      swatch.classList.add('active');
      currentColor = swatch.dataset.color;
    });
  });

  sizeDots.forEach(dot => {
    dot.addEventListener('click', () => {
      sound.playButtonClick();
      sizeDots.forEach(d => d.classList.remove('active'));
      dot.classList.add('active');
      currentSize = parseInt(dot.dataset.size, 10);
    });
  });

  let lastDoodleX = 0;
  let lastDoodleY = 0;

  function startDoodle(e) {
    if (!body.classList.contains('doodle-active')) return;
    isDoodling = true;
    saveDoodleState();
    const x = e.clientX || (e.touches && e.touches[0].clientX);
    const y = e.clientY || (e.touches && e.touches[0].clientY);
    lastDoodleX = x;
    lastDoodleY = y;

    if (currentTool === 'stamp') {
      ctx.font = `${currentSize * 4}px sans-serif`;
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      const stamps = ['⭐', '💡', '❤️', '☕', '🎨', '⚡', '✨'];
      const randomStamp = stamps[Math.floor(Math.random() * stamps.length)];
      ctx.fillText(randomStamp, x, y);
      sound.playStamp();
      spawnGraphiteSparks(x, y, 6);
      isDoodling = false;
      return;
    }

    drawDoodle(e);
  }

  function drawDoodle(e) {
    if (!isDoodling || !body.classList.contains('doodle-active')) return;
    const x = e.clientX || (e.touches && e.touches[0].clientX);
    const y = e.clientY || (e.touches && e.touches[0].clientY);

    ctx.lineWidth = currentSize;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';

    if (currentTool === 'eraser') {
      ctx.globalCompositeOperation = 'destination-out';
      sound.playEraserRub();
    } else if (currentTool === 'marker') {
      ctx.globalCompositeOperation = 'source-over';
      ctx.strokeStyle = currentColor + '66'; // Semi-transparent
      sound.playPencilScribble();
    } else {
      ctx.globalCompositeOperation = 'source-over';
      ctx.strokeStyle = currentColor;
      sound.playPencilScribble();
    }

    ctx.beginPath();
    ctx.moveTo(lastDoodleX, lastDoodleY);
    ctx.lineTo(x, y);
    ctx.stroke();

    lastDoodleX = x;
    lastDoodleY = y;
  }

  function stopDoodle() {
    isDoodling = false;
  }

  doodleCanvas.addEventListener('mousedown', startDoodle);
  doodleCanvas.addEventListener('mousemove', drawDoodle);
  doodleCanvas.addEventListener('mouseup', stopDoodle);
  doodleCanvas.addEventListener('touchstart', startDoodle, { passive: true });
  doodleCanvas.addEventListener('touchmove', drawDoodle, { passive: true });
  doodleCanvas.addEventListener('touchend', stopDoodle);

  doodleUndoBtn.addEventListener('click', () => {
    sound.playButtonClick();
    if (undoHistory.length > 0) {
      const prev = undoHistory.pop();
      ctx.putImageData(prev, 0, 0);
    }
  });

  doodleClearBtn.addEventListener('click', () => {
    sound.playEraserRub();
    ctx.clearRect(0, 0, doodleCanvas.width, doodleCanvas.height);
    undoHistory = [];
    setCharacterBubble("Canvas scrubbed clean! Ready for a fresh draft! 🧹", 3000);
  });

  doodleDownloadBtn.addEventListener('click', () => {
    sound.playSuccessChime();
    const link = document.createElement('a');
    link.download = 'atelier-sketch-doodle.png';
    link.href = doodleCanvas.toDataURL();
    link.click();
    setCharacterBubble("Artwork saved to your device! 💾🎨", 3500);
  });

  /* ==========================================================================
     Graphite Sparks & Confetti Physics Simulation
     ========================================================================== */

  const fxCanvas = document.getElementById('fxCanvas');
  const fxCtx = fxCanvas.getContext('2d');
  let particles = [];

  function spawnGraphiteSparks(x, y, count = 12) {
    for (let i = 0; i < count; i++) {
      particles.push({
        x: x,
        y: y,
        vx: (Math.random() - 0.5) * 8,
        vy: (Math.random() - 0.5) * 8 - 2,
        size: Math.random() * 3 + 1,
        color: Math.random() > 0.5 ? '#1C1917' : '#F59E0B',
        alpha: 1,
        gravity: 0.2,
        drag: 0.98,
        type: 'spark'
      });
    }
  }

  function spawnConfettiCannon() {
    const colors = ['#EF4444', '#F59E0B', '#10B981', '#3B82F6', '#8B5CF6', '#EC4899'];
    for (let i = 0; i < 90; i++) {
      particles.push({
        x: window.innerWidth / 2,
        y: window.innerHeight / 2,
        vx: (Math.random() - 0.5) * 18,
        vy: Math.random() * -16 - 4,
        size: Math.random() * 8 + 4,
        color: colors[Math.floor(Math.random() * colors.length)],
        alpha: 1,
        gravity: 0.35,
        drag: 0.97,
        rotation: Math.random() * 360,
        vRot: (Math.random() - 0.5) * 12,
        type: 'confetti'
      });
    }
  }

  function renderFx() {
    fxCtx.clearRect(0, 0, fxCanvas.width, fxCanvas.height);
    for (let i = particles.length - 1; i >= 0; i--) {
      const p = particles[i];
      p.x += p.vx;
      p.y += p.vy;
      p.vy += p.gravity;
      p.vx *= p.drag;
      p.vy *= p.drag;
      p.alpha -= 0.015;

      if (p.alpha <= 0) {
        particles.splice(i, 1);
        continue;
      }

      fxCtx.save();
      fxCtx.globalAlpha = Math.max(0, p.alpha);
      fxCtx.fillStyle = p.color;

      if (p.type === 'confetti') {
        p.rotation += p.vRot;
        fxCtx.translate(p.x, p.y);
        fxCtx.rotate((p.rotation * Math.PI) / 180);
        fxCtx.fillRect(-p.size / 2, -p.size / 2, p.size, p.size * 0.6);
      } else {
        fxCtx.beginPath();
        fxCtx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
        fxCtx.fill();
      }
      fxCtx.restore();
    }
    requestAnimationFrame(renderFx);
  }
  renderFx();

  /* ==========================================================================
     Keyboard Shortcuts & Modal
     ========================================================================== */

  shortcutsBtn.addEventListener('click', () => {
    sound.playButtonClick();
    shortcutsModal.classList.remove('hidden');
  });

  shortcutsCloseBtn.addEventListener('click', () => {
    sound.playButtonClick();
    shortcutsModal.classList.add('hidden');
  });

  window.addEventListener('keydown', (e) => {
    // Avoid hotkeys when user is actively typing in inputs
    if (['INPUT', 'TEXTAREA'].includes(document.activeElement.tagName) && e.key !== 'Escape') {
      return;
    }

    const key = e.key.toLowerCase();
    if (key === 'l') {
      toggleLight();
    } else if (key === 'd') {
      toggleDoodleMode();
    } else if (key === 's') {
      soundToggle.click();
    } else if (key === 't') {
      if (loginCard.classList.contains('theme-white')) setCardStyle('black');
      else setCardStyle('white');
    } else if (key === '1') {
      switchAuthTab('signin');
    } else if (key === '2') {
      switchAuthTab('signup');
    } else if (key === '3') {
      switchAuthTab('passkey');
    } else if (key === '?' || (e.shiftKey && key === '/')) {
      shortcutsModal.classList.toggle('hidden');
    } else if (e.key === 'Escape') {
      shortcutsModal.classList.add('hidden');
      successModal.classList.add('hidden');
      forgotModal.classList.add('hidden');
      if (body.classList.contains('doodle-active')) toggleDoodleMode(false);
    }
  });

  // Shake animation CSS
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

  // Initial Intro Boot
  setTimeout(() => {
    playIntroSequence();
  }, 400);
});
