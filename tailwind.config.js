/** @type {import('tailwindcss').Config} */
module.exports = {
  mode: 'jit',

  content: [
    '_plugins/*.rb',
    '_includes/**/*.html',
    '_layouts/**/*.html',
    '_pages/**/*.*',
    '_posts/*.*',
    'posts/*.*',
    'pages/**/*.*',
    '*.html',
    '*.md'
    ],
    
  theme: {
    extend: {
      colors: {
        'fire': {
          '50': '#fff8ec',
          '100': '#ffefd3',
          '200': '#ffdca7',
          '300': '#ffc16f',
          '400': '#ff9b35',
          '500': '#ff7e0e',
          '600': '#f26104',
          '700': '#c94805',
          '800': '#aa3d0e',
          '900': '#80310e',
          '950': '#451605',
        },
        'bahama': {
          '50': '#f1f9fe',
          '100': '#e2f2fc',
          '200': '#bee4f9',
          '300': '#84cff5',
          '400': '#43b7ed',
          '500': '#1b9edc',
          '600': '#0d7ebc',
          '700': '#0c6497',
          '800': '#0e567e',
          '900': '#124868',
          '950': '#0c2d45',
        },
      }
    },
  },
  plugins: [require("@tailwindcss/typography"),
    require("daisyui"),
  ],

  daisyui: {
    // https://themes.ionevolve.com/
    themes: [
        "light", 
        "dim",
        "bumblebee",
        { "fire": {
          // background colors
          "base-100": "#fff",
          "base-200": "#eee",
          "base-300": "#ddd",
          "base-400": "#ccc",
          "base-content": "#333",
          // primary (tab) colors
          "primary": "#66cc8a",
          "primary-content": "#f9fafb",      
          "primary-focus": "#41be6d",
          // accent color
          'accent' : '#ea5234',    
          'accent-focus' : '#d03516',
          'accent-content' : '#f9fafb',
          //
          "sidebar": "#007777",
        }
      }
    ],
  },
}

