/obj/item/gun/ballistic/automatic/toy
	name = "foam force SMG"
	desc = "A prototype three-round burst toy submachine gun. Ages 8 and up."
	icon_state = "saber"
	selector_switch_icon = TRUE
	inhand_icon_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/toy/smg
	fire_sound = 'sound/items/syringeproj.ogg'
	force = 0
	throwforce = 0
	burst_size = 3
	can_suppress = TRUE
	clumsy_check = FALSE
	item_flags = NONE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	casing_ejector = FALSE

/obj/item/gun/ballistic/automatic/toy/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/automatic/toy/unrestricted/riot
	mag_type = /obj/item/ammo_box/magazine/toy/smg/riot

/obj/item/gun/ballistic/automatic/pistol/toy
	name = "foam force pistol"
	desc = "A small, easily concealable toy handgun. Ages 8 and up."
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	fire_sound = 'sound/items/syringeproj.ogg'
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	unique_reskin = list("Command" = "toypistol_cmd",
						"Service" = "toypistol_srv",
						"Support" = "toypistol_spt")

/obj/item/gun/ballistic/automatic/pistol/toy/reskin_obj(mob/M)
	..()
	switch(icon_state)
		if("toypistol_cmd")
			inhand_icon_state = "toypistol_cmd"
		if("toypistol_srv")
			inhand_icon_state = "toypistol_srv"
		if("toypistol_spt")
			inhand_icon_state = "toypistol_spt"
	M.update_held_items()
	/*to_chat(M, span_notice("As you reskin [src] to [icon_state], it switches to inhand state [inhand_icon_state]."))*/

/obj/item/gun/ballistic/automatic/pistol/toy/AltClick(mob/user)
	if(unique_reskin && !current_skin && user.canUseTopic(src, be_close = TRUE, no_dexterity = TRUE))
		reskin_obj(user)
		update_overlays()
	reskin_obj(user)
	..update_overlays()
	/*to_chat(user, span_notice("As you reskin [src], it became icon state [inhand_icon_state]."))*/

/obj/item/gun/ballistic/automatic/pistol/toy/riot
	mag_type = /obj/item/ammo_box/magazine/toy/pistol/riot

/obj/item/gun/ballistic/automatic/pistol/riot/Initialize(mapload)
	magazine = new /obj/item/ammo_box/magazine/toy/pistol/riot(src)
	return ..()

/obj/item/gun/ballistic/shotgun/toy
	name = "foam force shotgun"
	desc = "A toy shotgun with wood furniture and a four-shell capacity underneath. Ages 8 and up."
	force = 0
	throwforce = 0
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy
	fire_sound = 'sound/items/syringeproj.ogg'
	clumsy_check = FALSE
	item_flags = NONE
	casing_ejector = FALSE
	can_suppress = FALSE
	weapon_weight = WEAPON_LIGHT
	pb_knockback = 0
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN

/obj/item/gun/ballistic/shotgun/toy/handle_chamber()
	. = ..()
	if(chambered && !chambered.loaded_projectile)
		qdel(chambered)

/obj/item/gun/ballistic/shotgun/toy/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/shotgun/toy/crossbow
	name = "foam force crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "foamcrossbow"
	inhand_icon_state = "crossbow"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	worn_icon_state = "gun"
	worn_icon = null
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy/crossbow
	fire_sound = 'sound/items/syringeproj.ogg'
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	gun_flags = NONE

/obj/item/gun/ballistic/automatic/c20r/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "donksoft SMG"
	desc = "A bullpup three-round burst toy SMG, designated 'C-20r'. Ages 8 and up."
	can_suppress = TRUE
	item_flags = NONE
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45/riot
	casing_ejector = FALSE
	clumsy_check = FALSE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN
	unique_reskin = list("Command" = "c20r_cmd",
						"Service" = "c20r_srv",
						"Support" = "c20r_spt")

/obj/item/gun/ballistic/automatic/c20r/toy/reskin_obj(mob/M)
	..()
	switch(icon_state)
		if("c20r_cmd")
			inhand_icon_state = "c20r_cmd"
		if("c20r_srv")
			inhand_icon_state = "c20r_srv"
		if("c20r_spt")
			inhand_icon_state = "c20r_spt"
	M.update_held_items()

/obj/item/gun/ballistic/automatic/c20r/toy/AltClick(mob/user)
	if(unique_reskin && !current_skin && user.canUseTopic(src, be_close = TRUE, no_dexterity = TRUE))
		reskin_obj(user)
		update_overlays()
	reskin_obj(user)
	..update_overlays()
	/*to_chat(user, span_notice("As you reskin [src], it became icon state [inhand_icon_state]."))*/

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45

/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot
	mag_type = /obj/item/ammo_box/magazine/toy/smgm45/riot

/obj/item/gun/ballistic/automatic/l6_saw/toy //This is the syndicate variant with syndicate firing pin and riot darts.
	name = "donksoft LMG"
	desc = "A heavily modified toy light machine gun, designated 'L6 SAW'. Ages 8 and up."
	fire_sound = 'sound/items/syringeproj.ogg'
	can_suppress = FALSE
	item_flags = NONE
	mag_type = /obj/item/ammo_box/magazine/toy/m762/riot
	casing_ejector = FALSE
	clumsy_check = FALSE
	gun_flags = TOY_FIREARM_OVERLAY | NOT_A_REAL_GUN

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted //Use this for actual toys
	pin = /obj/item/firing_pin
	mag_type = /obj/item/ammo_box/magazine/toy/m762

/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot
	mag_type = /obj/item/ammo_box/magazine/toy/m762/riot
