#define BELLY_MEDICAL_REAGENTS list(\
		/datum/reagent/medicine/regen_jelly,\
		/datum/reagent/medicine/c2/seiver,\
		/datum/reagent/medicine/oxandrolone,\
		/datum/reagent/medicine/pen_acid,\
		/datum/reagent/medicine/potass_iodide,\
		/datum/reagent/medicine/sal_acid,\
		/datum/reagent/medicine/c2/synthflesh,\
		/datum/reagent/medicine/atropine,\
		/datum/reagent/medicine/inacusiate,\
		/datum/reagent/medicine/oculine,\
		/datum/reagent/medicine/salglu_solution,\
		/datum/reagent/medicine/spaceacillin,\
		/datum/reagent/medicine/neurine,\
		/datum/reagent/medicine/mannitol,\
		/datum/reagent/medicine/psicodine,\
		/datum/reagent/consumable/caramel\
	)

/obj/item/reagent_containers/bellyhypo
	name = "cyborg belly hypo"
	desc = "For borgs with sleeper modules, this allows direct application of treatment to the module's occupant using a number of powerful, life-saving medications.  (Use in-hand to inject occupant, alt-click to change injection amount, ctrl-click to open reagent menu.)"
	icon = 'icons/obj/medical/syringe.dmi'
	inhand_icon_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(2,5,10,15)

	/** The maximum volume for each reagent stored in this hypospray
	 * In most places we add + 1 because we're secretly keeping [max_volume_per_reagent + 1]
	 * units, so that when this reagent runs out it's not wholesale removed from the reagents
	 */
	var/max_volume_per_reagent = 50
	/// Cell cost for charging a reagent
	var/charge_cost = 50
	/// Counts up to the next time we charge
	var/charge_timer = 0
	/// Time it takes for shots to recharge (in seconds)
	var/recharge_time = 5
	///Optional variable to override the temperature add_reagent() will use
	///var/dispensed_temperature = DEFAULT_REAGENT_TEMPERATURE
	var/dispensed_temperature = 2000 //Seiver is the only thing that cares about this I think.  this PROBABLY won't nuke lizardfolk?  I hope?
	/// If this hypospray has been upgraded
	var/upgraded = FALSE

	/// The basic reagents that come with this hypo
	var/list/default_reagent_types
	/// The expanded suite of reagents that comes from upgrading this hypo
	var/list/expanded_reagent_types

	/// The reagents we're actually storing
	var/datum/reagents/stored_reagents
	/// The reagent we've selected to dispense
	var/datum/reagent/selected_reagent
	/// The theme for our UI (hacked hypos get syndicate UI)
	var/tgui_theme = "ntos"
	var/selected_occupant = 1

/obj/item/reagent_containers/bellyhypo/Initialize(mapload)
	. = ..()
	stored_reagents = new(new_flags = NO_REACT)
	stored_reagents.maximum_volume = length(default_reagent_types) * (max_volume_per_reagent + 1)
	for(var/reagent in default_reagent_types)
		add_new_reagent(reagent)
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/bellyhypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/// Every [recharge_time] seconds, recharge some reagents for the cyborg
/obj/item/reagent_containers/bellyhypo/process(delta_time)
	charge_timer += delta_time
	if(charge_timer >= recharge_time)
		regenerate_reagents(default_reagent_types)
		if(upgraded)
			regenerate_reagents(expanded_reagent_types)
		charge_timer = 0
	return 1

/// Use this to add more chemicals for the bellyhypo to produce.
/obj/item/reagent_containers/bellyhypo/proc/add_new_reagent(datum/reagent/reagent)
	stored_reagents.add_reagent(reagent, (max_volume_per_reagent + 1), reagtemp = dispensed_temperature, no_react = TRUE)

/// Regenerate our supply of all reagents (if they're not full already)
/obj/item/reagent_containers/bellyhypo/proc/regenerate_reagents(list/reagents_to_regen)
	if(iscyborg(src.loc))
		var/mob/living/silicon/robot/cyborg = src.loc
		if(cyborg?.cell)
			for(var/reagent in reagents_to_regen)
				var/datum/reagent/reagent_to_regen = reagent
				if(!stored_reagents.has_reagent(reagent_to_regen, max_volume_per_reagent))
					cyborg.cell.use(charge_cost)
					stored_reagents.add_reagent(reagent_to_regen, 5, reagtemp = dispensed_temperature, no_react = TRUE)

/obj/item/reagent_containers/bellyhypo/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BorgHypo", name)
		ui.open()

/obj/item/reagent_containers/bellyhypo/CtrlClick(mob/user)
	ui_interact(user)

/obj/item/reagent_containers/bellyhypo/ui_data(mob/user)
	var/list/available_reagents = list()
	for(var/datum/reagent/reagent in stored_reagents.reagent_list)
		if(reagent)
			available_reagents.Add(list(list(
				"name" = reagent.name,
				"volume" = round(reagent.volume, 0.01) - 1,
				"description" = reagent.description,
			))) // list in a list because Byond merges the first list...

	var/data = list()
	data["theme"] = tgui_theme
	data["maxVolume"] = max_volume_per_reagent
	data["reagents"] = available_reagents
	data["selectedReagent"] = selected_reagent?.name
	return data

/obj/item/reagent_containers/bellyhypo/attack_self(mob/user)
	var/mob/living/silicon/robot/borg = src.loc
	
	if(length(borg.occupants) == 0)
		balloon_alert(user, "No occupants!")
		return
	if(length(borg.occupants) == 1)
		selected_occupant = 1
		//balloon_alert(user, "Trying for base occ!")

	var/mob/living/carbon/injectee = borg.occupants[selected_occupant]

	if(!istype(injectee))
		balloon_alert(user, "No valid occupant to aid!")
		return
	if(!selected_reagent)
		balloon_alert(user, "No reagent selected!")
		return
	if(!stored_reagents.has_reagent(selected_reagent.type, amount_per_transfer_from_this))
		balloon_alert(user, "Not enough of [selected_reagent.name] - wait for it to recharge!")
		return

	if(injectee.try_inject(user, user.zone_selected, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE | INJECT_CHECK_PENETRATE_THICK))
		// This is the in-between where we're storing the reagent we're going to inject the injectee with
		// because we cannot specify a singular reagent to transfer in trans_to
		var/datum/reagents/hypospray_injector = new()
		stored_reagents.remove_reagent(selected_reagent.type, amount_per_transfer_from_this)
		hypospray_injector.add_reagent(selected_reagent.type, amount_per_transfer_from_this, reagtemp = dispensed_temperature, no_react = TRUE)

		to_chat(injectee, span_warning("Healing chems wash in around you!  [src] gave you [amount_per_transfer_from_this]u of [selected_reagent.name]."))
		to_chat(user, span_notice("You give [injectee] [amount_per_transfer_from_this]u of [selected_reagent.name]."))

		if(injectee.reagents)
			hypospray_injector.trans_to(injectee, amount_per_transfer_from_this, transfered_by = user, methods = INJECT)
			balloon_alert(user, "[amount_per_transfer_from_this] unit\s applied")
			log_combat(user, injectee, "injected", src, "(CHEMICALS: [selected_reagent])")
	else
		balloon_alert(user, "[user.zone_selected] is blocked!")

/obj/item/reagent_containers/bellyhypo/ui_act(action, params)
	. = ..()
	if(.)
		return

	for(var/datum/reagent/reagent in stored_reagents.reagent_list)
		if(reagent.name == action)
			selected_reagent = reagent
			. = TRUE
			playsound(loc, 'sound/effects/pop.ogg', 50, FALSE)

			var/mob/living/silicon/robot/cyborg = src.loc
			balloon_alert(cyborg, "dispensing [selected_reagent.name]")
			break

/obj/item/reagent_containers/bellyhypo/examine(mob/user)
	. = ..()
	. += "Currently loaded: [selected_reagent ? "[selected_reagent]. [selected_reagent.description]" : "nothing."]"
	. += span_notice("<i>Alt+Click</i> to change transfer amount. Currently set to [amount_per_transfer_from_this]u.")

/obj/item/reagent_containers/bellyhypo/AltClick(mob/living/user)
	. = ..()
	var/mob/living/silicon/robot/borg = user
	if(length(borg.occupants) < 2)
		selected_occupant = 1
	else
		selected_occupant = ((selected_occupant)%length(borg.occupants))+1
		balloon_alert(user, "Medicating [(borg.occupants[selected_occupant])].")
	if(user.stat == DEAD || user != loc)
		return //IF YOU CAN HEAR ME SET MY TRANSFER AMOUNT TO 1
	change_transfer_amount(user)

/// Default Medborg Hypospray
/obj/item/reagent_containers/bellyhypo/medical
	default_reagent_types = BELLY_MEDICAL_REAGENTS
	expanded_reagent_types = BELLY_MEDICAL_REAGENTS