--Scoped viewmodel FOV fix by Cheeseot
local scopefixfov = 0;
local recentscope = 0;
function pfixscoped()
local me = entities.GetLocalPlayer();
if me ~=nil then
	local pfixscope = me:GetProp("m_bIsScoped");
	if pfixscope == 256 then pfixscope = 0 end
	if pfixscope == 257 then pfixscope = 1 end
	if pfixscope == 0 and recentscope == 0 then
		if gui.GetValue("vis_view_model_fov") ~= 0 then
		scopefixfov = gui.GetValue("vis_view_model_fov");
		end
	end
	if pfixscope == 1 then
		recentscope = 1;
		if recentscope == 1 and gui.GetValue("vis_view_model_fov") ~= 0 then
			gui.SetValue("vis_view_model_fov", 0);
		end
	end
	if pfixscope == 0 and recentscope == 1 then
		gui.SetValue("vis_view_model_fov", scopefixfov);
		recentscope = 0;
	end
end	
end

callbacks.Register("Draw", "pfixscoped", pfixscoped)