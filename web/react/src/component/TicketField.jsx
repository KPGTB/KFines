const TicketField = (props) => {
    return (
        <fieldset>
            <legend>{props.name}</legend>
            {
                props.input === "sex" ?
                    <div>
                        <button onClick={() => props.onChange(0)} className={props.selected === 0 ? "sex" : props.selected === 1 ?  "sex notSelected" : "sex"} disabled={props.completed}>{props.male}</button>
                        
                        &nbsp;/&nbsp;

                        <button onClick={() => props.onChange(1)} className={props.selected === 1 ? "sex" : props.selected === 0 ? "sex notSelected" : "sex"} disabled={props.completed}>{props.female}</button>
                    </div>
                : props.input === "textarea" ?
                    <textarea spellCheck="false" style={{resize: "none"}} rows="5" onChange={props.onChange} readOnly={props.completed}>{props.completed ? props.selected : undefined}</textarea>
                : 
                    <>
                        {props.input === "number" ? "$" : ""}<input type={props.input} spellCheck="false" onChange={props.onChange} readOnly={props.completed} value={props.completed ? props.selected : undefined}/>
                    </>
            }
            
        </fieldset>
    )

}

export default TicketField