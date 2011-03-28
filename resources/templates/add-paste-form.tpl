<form method="post">
    <ul>
        <li><input type="text" name="title"/></li>
        <li><textarea rows="15" cols="60" name="source-code"></textarea></li>
        <li><textarea rows="5" cols="60" name="description"></textarea></li>
        <li>
            <select name="language">
                <possible-languages>
                    <option value="$(lang-value)"><lang-name/></option>
                </possible-languages>
            </select>
        </li>
        <li><input type="submit" value="Paste!"/></li>
    </ul>
</form>