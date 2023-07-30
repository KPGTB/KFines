import { Component } from "react"
import { useNui, callNui } from "./utils/FiveM"

export default class App extends Component {
    state = {
        visible: false
    }

    render() {
        return (
            this.state.visible ?
                <div className="App">
                    <img src="../assets/logo.png" alt="Images and styles aren't visible in serve mode!" />
                    <h1>Hello World!</h1>
                </div>
            :
                undefined
        )
    }

    componentDidMount() {
        useNui("visible", (data) => this.setState({visible:data}))
        useNui('visible_check', () => {
            callNui('visible_check_cb', this.state.visible)
        })
    }
}