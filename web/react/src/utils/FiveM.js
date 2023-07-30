const handlers = new Map()

function useNui(action, handler) {
    if(!handlers.has(action)) {
        handlers.set(action, [])
    }

    handlers.get(action).push(handler)
}

function callNui(action, data, handler) {
    fetch(`https://${GetParentResourceName()}/${action}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(data)
    }).then(resp => resp.json()).then(resp => {
        if(handler !== undefined) {
            handler(resp)
        }
    })
}

window.addEventListener('message', (event) => {
    const action = event.data.action
    const data = event.data.data

    if(action === undefined) {
        return
    }
    if(!handlers.has(action)) {
        return
    }

    handlers.get(action).forEach(handler => {
        handler(data)
    })
})


export {useNui,callNui}