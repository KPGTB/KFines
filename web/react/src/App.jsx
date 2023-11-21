import {Component} from "react"
import {useNui, callNui} from "./utils/FiveM"
import TicketField from "./component/TicketField.jsx"

export default class App extends Component {
	state = {
		visible: false,
		locale: {},
		ready: false,
		completed: false,
		policeName: "",
		policeRank: "",
		policeBadge: "",
		citizenName: "",
		citizenSex: -1,
		citizenDOB: "",
		fine: 0,
		reason: "",
		signature: "",
		date: "",
		payUntil: "",
		id: -1,
		paid: false,
		job: "",
		jobInfo: "",
	}

	render() {
		return this.state.visible && this.state.ready ? (
			<div className="App">
				<header>
					<div className="left">
						<img
							src={`../assets/${this.state.jobInfo.logo}`}
							alt="logo"
							width="50px"
							height="50px"
						/>
						<div>
							<div class="department">
								{this.state.jobInfo.name}
							</div>
							<div class="title">
								{this.state.locale.nui_title}
							</div>
						</div>
					</div>
					<div className="right">
						<div className="city">
							{this.state.jobInfo.location}
						</div>
						<div className="currentDate">
							{this.state.date.toLocaleString()}
						</div>
					</div>
				</header>
				<fieldset className="category">
					<legend className="catType">
						{this.state.locale.nui_type_officer}
					</legend>

					<TicketField
						input="text"
						completed={this.state.completed}
						selected={this.state.policeName}
						name={this.state.locale.nui_input_name}
						onChange={(el) =>
							this.setState({policeName: el.target.value})
						}
					/>

					<TicketField
						input="text"
						completed={this.state.completed}
						selected={this.state.policeRank}
						name={this.state.locale.nui_input_rank}
						onChange={(el) =>
							this.setState({policeRank: el.target.value})
						}
					/>

					<TicketField
						input="text"
						completed={this.state.completed}
						selected={this.state.policeBadge}
						name={this.state.locale.nui_input_badge}
						onChange={(el) =>
							this.setState({policeBadge: el.target.value})
						}
					/>
				</fieldset>
				<fieldset className="category">
					<legend className="catType">
						{this.state.locale.nui_type_citizen}
					</legend>

					<TicketField
						input="text"
						completed={this.state.completed}
						selected={this.state.citizenName}
						name={this.state.locale.nui_input_name}
						onChange={(el) =>
							this.setState({citizenName: el.target.value})
						}
					/>

					<TicketField
						input="sex"
						completed={this.state.completed}
						male={this.state.locale.nui_male}
						female={this.state.locale.nui_female}
						selected={this.state.citizenSex}
						name={this.state.locale.nui_input_sex}
						onChange={(sex) => this.setState({citizenSex: sex})}
					/>

					<TicketField
						input="text"
						completed={this.state.completed}
						selected={
							this.state.completed ? this.state.citizenDOB : ""
						}
						name={this.state.locale.nui_input_dob}
						onChange={(el) =>
							this.setState({citizenDOB: el.target.value})
						}
					/>
				</fieldset>
				<fieldset className="category">
					<legend className="catType">
						{this.state.locale.nui_type_ticket}
					</legend>

					<TicketField
						input="number"
						completed={this.state.completed}
						selected={this.state.fine}
						name={this.state.locale.nui_input_fine}
						onChange={(el) =>
							this.setState({fine: parseInt(el.target.value)})
						}
					/>

					<TicketField
						input="textarea"
						completed={this.state.completed}
						selected={this.state.reason}
						name={this.state.locale.nui_input_reason}
						onChange={(el) =>
							this.setState({reason: el.target.value})
						}
					/>

					<fieldset>
						<legend>{this.state.locale.nui_input_payuntil}</legend>
						<div>{this.state.payUntil.toLocaleString()}</div>
					</fieldset>
				</fieldset>

				<footer>
					<button
						onClick={
							this.state.completed
								? this.state.paid
									? undefined
									: this.pay.bind(this)
								: this.apply.bind(this)
						}
					>
						{this.state.completed
							? this.state.paid
								? undefined
								: this.state.locale.nui_pay
							: this.state.locale.nui_apply}
					</button>
					<button onClick={this.exit.bind(this)}>
						{this.state.locale.nui_exit}
					</button>
					<TicketField
						input="text"
						completed={this.state.completed}
						selected={this.state.signature}
						name={this.state.locale.nui_input_signature}
						onChange={(el) =>
							this.setState({signature: el.target.value})
						}
					/>
				</footer>
			</div>
		) : undefined
	}

	componentDidMount() {
		useNui("setLocale", (data) => {
			this.setState({locale: data})
		})
		useNui("setData", (data) => {
			this.setState(data)
			this.setState({
				visible: false,
				completed: true,
				ready: false,
			})
		})

		useNui("prepare", (data) => {
			let currentDate = new Date()
			let payUntil = new Date()

			if (!data.completed) {
				payUntil.setMilliseconds(
					payUntil.getMilliseconds() + data.payTime
				)
			} else {
				currentDate = new Date(this.state.date)
				payUntil = new Date(this.state.payUntil)
			}
			this.setState({
				ready: true,
				date: currentDate,
				payUntil: payUntil,
				job: data.job,
				jobInfo: data.jobInfo,
			})
		})

		useNui("reset", () => {
			this.setState({
				ready: false,
				completed: false,
				policeName: "",
				policeRank: "",
				policeBadge: "",
				citizenName: "",
				citizenSex: -1,
				citizenDOB: "",
				fine: 0,
				reason: "",
				signature: "",
				date: "",
				payUntil: "",
				id: -1,
				paid: false,
				job: "",
				jobInfo: "",
			})
		})

		useNui("visible", (data) => this.setState({visible: data}))
		useNui("visible_check", () => {
			callNui("visible_check_cb", this.state.visible)
		})

		window.addEventListener("keydown", (event) => {
			if (event.isComposing) {
				return
			}
			if (event.code === "Escape") {
				this.exit()
			}
		})
	}

	apply() {
		this.exit()
		callNui("apply", this.state)
	}

	pay() {
		this.exit()
		callNui("pay", this.state.id)
	}

	exit() {
		callNui("exit")
		this.setState({open: false, ready: false})
	}
}
