import React from 'react'
import ReactDOM from 'react-dom'

function App() {
  return (
    <div>
      <h1>{`App-version [${env.ENV_NAME}]: ${env.GIT_SHA.slice(0,7)}`}</h1>
      <h2>{`Build created at ${timestamp}`}</h2>
    </div>
  );
}
export default App;

ReactDOM.render(
  <App />,
  document.getElementsByTagName('app-root')[0]
);
