import React from 'react'
import * as colors from '@bekk/storybook/build/lib/constants/styles';

function ColorCircle(attrs) {
  const basecolor = attrs.base;

  return (
    <div>
      <svg>
          <circle cx={75} cy={75} r={70} fill={colors[basecolor]} />
          <rect width="70" height="70" x="85" y="44" fill={colors[`${basecolor}_KONTRAST`]} />
          <text x="175" y="80" fill="white">{basecolor.substring(0,1).toUpperCase()}{basecolor.substring(1).toLowerCase()}</text>
      </svg>
    </div>

  );
}
export default ColorCircle;
