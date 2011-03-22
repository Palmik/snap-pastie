<html>
  <head>
    <title>Echo Page</title>
  </head>
  <body>
    <div id="recent-pastes">
        <recent-pastes>
            <apply template="full-paste">
                <bind tag="title"><title/></bind>
                <bind tag="code"><code/></bind>
                <bind tag="description"><description/></bind>
                <bind tag="language"><language/></bind>
            </apply>
        </recent-pastes>
    </div>
  </body>
</html>
