-- Generated from EPA SWMM 5.2.4 (keywords.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local _ENV = R.strict

G.BuildupTypeWords = {[0] = S[355], S[738], S[739], S[740], S[741], (nil)}
G.CurveTypeWords = {[0] = S[742], S[743], S[744], S[745], S[746], S[747], S[662], S[748], S[749], S[750], S[751], S[752], (nil)}
G.DividerTypeWords = {[0] = S[753], S[754], S[662], S[755], (nil)}
G.EvapTypeWords = {[0] = S[756], S[757], S[692], S[758], S[1], S[759], S[760], (nil)}
G.FileTypeWords = {[0] = S[761], S[762], S[763], S[764], S[765], S[766], (nil)}
G.FileModeWords = {[0] = S[4], S[767], S[768], S[769], (nil)}
G.FlowUnitWords = {[0] = S[770], S[771], S[772], S[773], S[774], S[775], (nil)}
G.ForceMainEqnWords = {[0] = S[776], S[777], (nil)}
G.GageDataWords = {[0] = S[692], S[1], (nil)}
G.InfilModelWords = {[0] = S[778], S[779], S[780], S[781], S[782], (nil)}
G.InertDampingWords = {[0] = S[355], S[783], S[784], (nil)}
G.LinkOffsetWords = {[0] = S[664], S[785], (nil)}
G.LinkTypeWords = {[0] = S[659], S[660], S[661], S[662], S[663], nil}
G.LoadUnitsWords = {[0] = S[786], S[787], S[788], nil}
G.NodeTypeWords = {[0] = S[789], S[790], S[742], S[791], nil}
G.NoneAllWords = {[0] = S[355], S[351], (nil)}
G.NormalFlowWords = {[0] = S[673], S[792], S[793], S[355], (nil)}
G.NormalizerWords = {[0] = S[794], S[719], (nil)}
G.NoYesWords = {[0] = S[4], S[5], (nil)}
G.OffOnWords = {[0] = S[687], S[688], (nil)}
G.OldRouteModelWords = {[0] = S[355], S[795], S[796], S[797], S[798], (nil)}
G.OptionWords = {[0] = S[799], S[800], S[801], S[802], S[803], S[804], S[805], S[806], S[807], S[808], S[809], S[810], S[811], S[812], S[813], S[814], S[815], S[816], S[817], S[818], S[819], S[820], S[821], S[822], S[823], S[824], S[825], S[826], S[827], S[828], S[829], S[830], S[831], S[832], S[833], S[834], S[835], S[836], S[837], S[838], S[839], S[840], S[841], (nil)}
G.OrificeTypeWords = {[0] = S[842], S[843], (nil)}
G.OutfallTypeWords = {[0] = S[844], S[845], S[846], S[744], S[692], (nil)}
G.PatternTypeWords = {[0] = S[757], S[847], S[848], S[849], (nil)}
G.PondingUnitsWords = {[0] = S[850], S[851], nil}
G.ProcessVarWords = {[0] = S[852], S[853], S[183], S[664], S[794], (nil)}
G.PumpTypeWords = {[0] = S[854], S[855], S[856], S[857], S[858], S[859], nil}
G.QualUnitsWords = {[0] = S[860], S[861], S[862], (nil)}
G.RainTypeWords = {[0] = S[694], S[666], S[863], (nil)}
G.RainUnitsWords = {[0] = S[864], S[865], (nil)}
G.RelationWords = {[0] = S[754], S[866], S[867], S[868], S[869], S[870], (nil)}
G.ReportWords = {[0] = S[871], S[872], S[873], S[657], S[658], S[874], S[875], S[746], S[876], S[877], (nil)}
G.RouteModelWords = {[0] = S[355], S[878], S[879], S[880], S[881], (nil)}
G.RuleKeyWords = {[0] = S[202], S[882], S[883], S[884], S[885], S[886], S[887], (nil)}
G.SectWords = {[0] = S[888], S[889], S[890], S[891], S[892], S[893], S[894], S[895], S[896], S[897], S[898], S[899], S[900], S[901], S[902], S[903], S[904], S[905], S[906], S[907], S[908], S[909], S[910], S[911], S[912], S[913], S[914], S[915], S[916], S[917], S[918], S[919], S[920], S[921], S[922], S[923], S[924], S[925], S[926], S[927], S[928], S[929], S[930], S[931], S[932], S[933], S[934], S[935], S[936], S[937], S[938], S[939], S[940], S[941], S[942], S[943], S[944], (nil)}
G.SnowmeltWords = {[0] = S[945], S[2], S[3], S[946], (nil)}
G.SurchargeWords = {[0] = S[947], S[948], (nil)}
G.TempKeyWords = {[0] = S[692], S[1], S[949], S[950], S[951], (nil)}
G.TransectKeyWords = {[0] = S[952], S[203], S[953], (nil)}
G.TreatTypeWords = {[0] = S[946], S[185], (nil)}
G.UHTypeWords = {[0] = S[954], S[955], S[956], (nil)}
G.VolUnitsWords = {[0] = S[957], S[958], nil}
G.VolUnitsWords2 = {[0] = S[959], S[960], nil}
G.WashoffTypeWords = {[0] = S[355], S[739], S[961], S[962], (nil)}
G.WeirTypeWords = {[0] = S[963], S[964], S[965], S[966], S[967], (nil)}
G.XsectTypeWords = {[0] = S[968], S[969], S[970], S[971], S[972], S[966], S[973], S[869], S[974], S[975], S[976], S[977], S[978], S[979], S[980], S[981], S[982], S[983], S[984], S[985], S[986], S[987], S[988], S[723], S[989], S[990], (nil)}

