extends Spatial

func _ready():
	var sdk = StaticSDK.GetSDK()
	sdk.connect("SkinChanged", self, "OnSkinChanged")

	SetSkin(sdk.SkinDB.SkinsDict[sdk.SelectedSkinId])

func OnSkinChanged(skinId):
	SetSkin(StaticSDK.GetSDK().SkinDB.SkinsDict[skinId])

func SetSkin(skin: OutdoorSkin):
	$Armature/Skeleton/Outhouse.get_surface_material(0).set("albedo_texture", skin.SkinTexture)
