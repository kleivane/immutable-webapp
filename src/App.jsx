import React from 'react'
import ReactDOM from 'react-dom'
import styled from 'styled-components'
import * as colors from '@bekk/storybook/build/lib/constants/styles';

const AppContainer = styled.div`
  background-color: ${colors.OVERSKYET};
`

function App() {
  return (
    <AppContainer>
      <h1>{`App-version [${env.ENV_NAME}]: ${env.GIT_SHA.slice(0,7)}`}</h1>
      <h2>{`Build created at ${timestamp}`}</h2>
      <h2>{`Build deploy at ${env.CREATED_AT}`}</h2>
    </AppContainer>
  );
}
export default App;

ReactDOM.render(
  <App />,
  document.getElementsByTagName('app-root')[0]
);
