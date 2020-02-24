import React from 'react'
import ReactDOM from 'react-dom'
import styled from 'styled-components'
import dateformat from './date'
import { createGlobalStyle } from 'styled-components'
import * as colors from '@bekk/storybook/build/lib/constants/styles';
import ColorCircle from './ColorCircle'


const GlobalStyle = createGlobalStyle`
  body {
    background-color:  ${colors.BEKK_SORT};
    font-family: "Calibre Light", sans-serif;
    color: white;
  }
  h1, h2 {
    font-family: Georgia, serif;
  }
`
function App() {
  return (
    <div>
      <GlobalStyle/ >
      <h1>{`App-version [${env.ENV_NAME}]: ${env.GIT_SHA.slice(0,7)}`}</h1>
      <ColorCircle base={color}/>
      <div>{`Build created at ${dateformat(timestamp)}`}</div>
      <div>{`Build deploy at ${dateformat(env.CREATED_AT)}`}</div>
    </div>
  );
}
export default App;

ReactDOM.render(
  <App />,
  document.getElementsByTagName('app-root')[0]
);
