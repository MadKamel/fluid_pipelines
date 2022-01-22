minetest.register_node(":pipes:pipe", {
	description = "Fluid Pipeline",
	tiles = {"pipe.png"},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("container", 1*1)
		meta:set_string("infotext", "Pipeline")
		meta:set_int("capacity", "20")
		local fs_content = "formspec_version[4]"..
			"size[10.5,11]"..
			"list[current_player;main;0.4,5.7;8,1;]"..
			"list[current_player;main;0.4,7.3;8,3;8]"..
			"listring[context;container]"..
			"list[context;container;0.2,0.6;1,1;0]"..
			"label[0.1,0.3;Pipeline Contents]"..
			"label[0.2,2;"..meta:get_int("capacity").."]"
		meta:set_string("formspec", fs_content)
	end,
	groups = {cracky = 1}
})


local get_pos = function(pos, x, z, capacity)
	node_pos = pos
	node_pos.x = pos.x + x
	node_pos.z = pos.z + z
	meta = minetest.get_meta(node_pos)
	minetest.log(capacity.." != "..meta:get_int("capacity").."?")
	if meta:get_int("capacity") then
		if meta:get_int("capacity") < capacity then
			meta:set_int("capacity", meta:get_int("capacity") + 1)
			--minetest.log("capacity increased by one at "..dump(node_pos))
			return true
		end
	end
	return false
end


minetest.register_abm({
	nodenames = {"pipes:pipe"},
	neighbors = {"pipes:pipe"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if meta:get_int("capacity") > 16 then
			meta:set_int("capacity", 16)
		elseif meta:get_int("capacity") < 0 then
			meta:set_int("capacity", 0)
		end

		if get_pos(pos, 1, 0, meta:get_int("capacity")) then
			meta:set_int("capacity", meta:get_int("capacity") - 1)
			--minetest.log("capacity lowered by one at "..dump(pos))
		end
		if get_pos(pos, -1, 0, meta:get_int("capacity")) then
			meta:set_int("capacity", meta:get_int("capacity") - 1)
			--minetest.log("capacity lowered by one at "..dump(pos))
		end
		if get_pos(pos, 0, 1, meta:get_int("capacity")) then
			meta:set_int("capacity", meta:get_int("capacity") - 1)
			--minetest.log("capacity lowered by one at "..dump(pos))
		end
		if get_pos(pos, 0, -1, meta:get_int("capacity")) then
			meta:set_int("capacity", meta:get_int("capacity") - 1)
			--minetest.log("capacity lowered by one at "..dump(pos))
		end

		-- Update the formspec/infotext data
		meta:set_string("infotext", "Pipeline: ("..meta:get_int("capacity")..")")
		local fs_content = "formspec_version[4]"..
			"size[10.5,11]"..
			"list[current_player;main;0.4,5.7;8,1;]"..
			"list[current_player;main;0.4,7.3;8,3;8]"..
			"listring[context;container]"..
			"list[context;container;0.2,0.6;1,1;0]"..
			"label[0.1,0.3;Pipeline Contents]"..
			"label[0.2,2;"..meta:get_int("capacity").."]"
		meta:set_string("formspec", fs_content)
	end
})