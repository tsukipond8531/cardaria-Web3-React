// backgrounds
import saiman from './background/saiman.jpg';
import astral from './background/astral.jpg';
import eoaalien from './background/eoaalien.jpg';
import panight from './background/panight.jpg';
import heroImg from './background/hero-img.jpg';
import hero2Img from './background/Hero2.png';

//marvelCards
import ant_man from './characters/AntMan.png';
import black_phanter from './characters/BlackPhanter.png';
import black_widow from './characters/BlackWidow.png';
import captain_america from './characters/CaptainAmerica.png';
import doctor_strange from './characters/DoctorStrange.png';
import hulk from './characters/Hulk.png';
import ikaris from './characters/ikaris.png';
import iron_man from './characters/IronMan.png';
import peter_quill from './characters/PeterQuill.png';
import sangchi from './characters/Sangchi.png';
import spiderman from './characters/SpiderMan.png';
import thor from './characters/Thor.png';

// logo
import cardariaLogo from './CardariaLogo.png';

// icon
import attack from './attack.png';
import defense from './defense.png';
import alertIcon from './alertIcon.svg';
import AlertIcon from './AlertIcon.jsx';

// players
import player01 from './player01.png';
import player02 from './player02.png';
import player01icon from './player01icon.png';
import player02icon from './player02icon.png';

// sounds
import attackSound from './sounds/attack.wav';
import defenseSound from './sounds/defense.mp3';
import explosion from './sounds/explosion.mp3';

export const marvelCards = [
  ant_man,
  black_phanter, 
  black_widow,
  captain_america,
  doctor_strange,
  hulk,
  ikaris, 
  iron_man,
  peter_quill,
  sangchi, 
  spiderman,
  thor
];

export {
  saiman,
  astral,
  eoaalien,
  panight,
  heroImg,
  hero2Img,

  ant_man,
  black_phanter, 
  black_widow,
  captain_america,
  doctor_strange,
  hulk,
  ikaris, 
  iron_man,
  peter_quill,
  sangchi, 
  spiderman,
  thor,

  cardariaLogo,

  attack,
  defense,
  alertIcon,
  AlertIcon,

  player01,
  player02,
  player01icon,
  player02icon,

  attackSound,
  defenseSound,
  explosion,
};

export const battlegrounds = [
  { id: 'bg-saiman', image: saiman, name: 'Saiman' },
  { id: 'bg-astral', image: astral, name: 'Astral' },
  { id: 'bg-eoaalien', image: eoaalien, name: 'Eoaalien' },
  { id: 'bg-panight', image: panight, name: 'Panight' },
];

export const gameRules = [
  'Card with the same defense and attack point will cancel each other out.',
  'Attack points from the attacking card will deduct the opposing player’s health points.',
  'If P1 does not defend, their health wil be deducted by P2’s attack.',
  'If P1 defends, P2’s attack is equal to P2’s attack - P1’s defense.',
  'If a player defends, they refill 3 Mana',
  'If a player attacks, they spend 3 Mana',
];