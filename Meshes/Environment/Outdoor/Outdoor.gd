extends Spatial

func _ready():
	StaticSDK.GetSDK().connect("SkinChanged", self, "OnSkinChanged")

func OnSkinChanged(skinId):
	SetSkin(StaticSDK.GetSDK().SkinDB.SkinsDict[skinId])

func SetSkin(skin: OutdoorSkin):
	$Armature/Skeleton/Outhouse.get_surface_material(0).set("albedo_texture", skin.SkinTexture)
