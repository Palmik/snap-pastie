<html>
  <head>
    <title>Echo Page</title>
  </head>
  <body>
    <apply template="add-paste-form">
        <bind tag="possible-languages">
            <possible-languages/>
        </bind>
    </apply>
    <div id="recent-pastes">
        <recent-pastes>
            <apply template="full-paste">
                <bind tag="title"><title/></bind>
                <bind tag="source-code"><source-code/></bind>
                <bind tag="description"><description/></bind>
                <bind tag="language"><language/></bind>
            </apply>
        </recent-pastes>
    </div>
    <possible-languages>
        <option value="$(lang-value)"><lang-name/></option>
    </possible-languages>
  </body>
</html>
