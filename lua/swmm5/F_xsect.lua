-- Generated from EPA SWMM 5.2.4 (xsect.c) by tools/c2x/emit_lua.py. Do not edit by hand;
-- fix the translator, rt.lua or overrides.lua instead.
local F, G, R, S, T, K = ...
local m_abs, m_sqrt, m_exp, m_sin, m_cos, m_tan, m_asin, m_acos, m_fmod =
      math.abs, math.sqrt, math.exp, math.sin, math.cos, math.tan, math.asin, math.acos, math.fmod
local DUMMY <const> = 0
local CIRCULAR <const> = 1
local FORCE_MAIN <const> = 24
local FILLED_CIRCULAR <const> = 2
local EGGSHAPED <const> = 15
local HORSESHOE <const> = 16
local GOTHIC <const> = 17
local CATENARY <const> = 18
local SEMIELLIPTICAL <const> = 19
local BASKETHANDLE <const> = 20
local SEMICIRCULAR <const> = 21
local RECT_CLOSED <const> = 3
local RECT_OPEN <const> = 4
local RECT_TRIANG <const> = 9
local RECT_ROUND <const> = 10
local MOD_BASKET <const> = 11
local TRAPEZOIDAL <const> = 5
local TRIANGULAR <const> = 6
local PARABOLIC <const> = 7
local POWERFUNC <const> = 8
local HORIZ_ELLIPSE <const> = 12
local VERT_ELLIPSE <const> = 13
local ARCH <const> = 14
local IRREGULAR <const> = 22
local CUSTOM <const> = 23
local STREET_XSECT <const> = 25
local _ENV = R.strict

G.N_A_Circ = 51
G.A_Circ = {[0] = 0.0, 0.00471, 0.0134, 0.024446, 0.0374, 0.05208, 0.068, 0.08505, 0.1033, 0.12236, 0.1423, 0.1631, 0.1845, 0.20665, 0.2292, 0.25236, 0.2759, 0.29985, 0.3242, 0.34874, 0.3736, 0.39878, 0.4237, 0.44907, 0.4745, 0.5, 0.5255, 0.55093, 0.5763, 0.60135, 0.6264, 0.65126, 0.6758, 0.70015, 0.7241, 0.74764, 0.7708, 0.79335, 0.8154, 0.8369, 0.8576, 0.87764, 0.8967, 0.91495, 0.932, 0.94792, 0.9626, 0.97555, 0.9866, 0.99516, 1.0}
G.N_R_Circ = 51
G.R_Circ = {[0] = 0.01, 0.0528, 0.1048, 0.1556, 0.2052, 0.254, 0.3016, 0.3484, 0.3944, 0.4388, 0.4824, 0.5248, 0.5664, 0.6064, 0.6456, 0.6836, 0.7204, 0.7564, 0.7912, 0.8244, 0.8568, 0.888, 0.9176, 0.9464, 0.9736, 1.0, 1.024, 1.048, 1.07, 1.0912, 1.11, 1.1272, 1.144, 1.1596, 1.174, 1.1848, 1.194, 1.2024, 1.21, 1.2148, 1.217, 1.2172, 1.215, 1.2104, 1.203, 1.192, 1.178, 1.1584, 1.132, 1.094, 1.0}
G.N_Y_Circ = 51
G.Y_Circ = {[0] = 0.0, 0.05236, 0.08369, 0.11025, 0.13423, 0.15643, 0.17755, 0.19772, 0.21704, 0.23581, 0.25412, 0.27194, 0.28948, 0.30653, 0.32349, 0.34017, 0.35666, 0.37298, 0.38915, 0.40521, 0.42117, 0.43704, 0.45284, 0.46858, 0.4843, 0.5, 0.51572, 0.53146, 0.54723, 0.56305, 0.57892, 0.59487, 0.61093, 0.6271, 0.64342, 0.65991, 0.67659, 0.6935, 0.71068, 0.72816, 0.74602, 0.76424, 0.78297, 0.80235, 0.8224, 0.84353, 0.86563, 0.8897, 0.91444, 0.94749, 1.0}
G.N_S_Circ = 51
G.S_Circ = {[0] = 0.0, 0.00529, 0.01432, 0.02559, 0.03859, 0.05304, 0.06877, 0.08551, 0.10326, 0.12195, 0.14144, 0.16162, 0.18251, 0.2041, 0.22636, 0.24918, 0.27246, 0.29614, 0.32027, 0.34485, 0.36989, 0.39531, 0.42105, 0.44704, 0.47329, 0.4998, 0.52658, 0.55354, 0.58064, 0.60777, 0.63499, 0.66232, 0.68995, 0.7177, 0.74538, 0.77275, 0.79979, 0.82658, 0.8532, 0.87954, 0.90546, 0.93095, 0.95577, 0.97976, 1.00291, 1.02443, 1.04465, 1.06135, 1.08208, 1.07662, 1.0}
G.N_W_Circ = 51
G.W_Circ = {[0] = 0.0, 0.28, 0.3919, 0.475, 0.5426, 0.6, 0.6499, 0.694, 0.7332, 0.7684, 0.8, 0.8285, 0.8542, 0.8773, 0.898, 0.9165, 0.933, 0.9474, 0.96, 0.9708, 0.9798, 0.9871, 0.9928, 0.9968, 0.9992, 1.0, 0.9992, 0.9968, 0.9928, 0.9871, 0.9798, 0.9708, 0.96, 0.9474, 0.933, 0.9165, 0.898, 0.8773, 0.8542, 0.8285, 0.8, 0.7684, 0.7332, 0.694, 0.6499, 0.6, 0.5426, 0.475, 0.3919, 0.28, 0.0}
G.N_A_Egg = 26
G.A_Egg = {[0] = 0.0, 0.0116, 0.0316, 0.055, 0.085, 0.12, 0.1555, 0.19, 0.225, 0.275, 0.32, 0.37, 0.42, 0.47, 0.515, 0.57, 0.62, 0.68, 0.73, 0.78, 0.835, 0.885, 0.925, 0.955, 0.98, 1.0}
G.N_R_Egg = 26
G.R_Egg = {[0] = 0.01, 0.13, 0.244, 0.302, 0.386, 0.465, 0.536, 0.611, 0.676, 0.735, 0.791, 0.854, 0.904, 0.941, 1.008, 1.045, 1.076, 1.115, 1.146, 1.162, 1.186, 1.193, 1.186, 1.162, 1.107, 1.0}
G.N_Y_Egg = 51
G.Y_Egg = {[0] = 0.0, 0.04912, 0.08101, 0.11128, 0.14161, 0.16622, 0.18811, 0.21356, 0.23742, 0.25742, 0.27742, 0.29741, 0.31742, 0.33742, 0.35747, 0.37364, 0.4, 0.41697, 0.43372, 0.45, 0.46374, 0.47747, 0.49209, 0.50989, 0.53015, 0.55, 0.56429, 0.57675, 0.58834, 0.6, 0.61441, 0.62967, 0.64582, 0.66368, 0.68209, 0.7, 0.71463, 0.72807, 0.74074, 0.75296, 0.765, 0.77784, 0.79212, 0.80945, 0.82936, 0.85, 0.86731, 0.88769, 0.914, 0.95, 1.0}
G.N_S_Egg = 51
G.S_Egg = {[0] = 0.0, 0.00295, 0.01331, 0.02629, 0.04, 0.05657, 0.075, 0.09432, 0.11473, 0.13657, 0.15894, 0.1803, 0.20036, 0.22, 0.23919, 0.25896, 0.28, 0.30504, 0.33082, 0.35551, 0.37692, 0.39809, 0.42, 0.44625, 0.47321, 0.5, 0.52255, 0.54481, 0.56785, 0.59466, 0.62485, 0.65518, 0.68181, 0.70415, 0.72585, 0.74819, 0.77482, 0.80515, 0.83534, 0.86193, 0.88465, 0.9069, 0.93, 0.95866, 0.98673, 1.01238, 1.03396, 1.05, 1.06517, 1.0538, 1.0}
G.N_W_Egg = 26
G.W_Egg = {[0] = 0.0, 0.325, 0.427, 0.508, 0.582, 0.642, 0.696, 0.746, 0.791, 0.836, 0.866, 0.896, 0.926, 0.956, 0.97, 0.985, 1.0, 0.985, 0.97, 0.94, 0.896, 0.836, 0.764, 0.642, 0.31, 0.0}
G.N_A_Horseshoe = 26
G.A_Horseshoe = {[0] = 0.0, 0.0181, 0.0508, 0.0908, 0.1326, 0.1757, 0.2201, 0.2655, 0.3118, 0.3587, 0.4064, 0.4542, 0.5023, 0.5506, 0.5987, 0.6462, 0.6931, 0.7387, 0.7829, 0.8253, 0.8652, 0.9022, 0.9356, 0.9645, 0.9873, 1.0}
G.N_R_Horseshoe = 26
G.R_Horseshoe = {[0] = 0.01, 0.104, 0.2065, 0.3243, 0.4322, 0.5284, 0.6147, 0.6927, 0.7636, 0.8268, 0.8873, 0.9417, 0.9905, 1.036, 1.077, 1.113, 1.143, 1.169, 1.189, 1.202, 1.208, 1.206, 1.195, 1.17, 1.126, 1.0}
G.N_Y_Horseshoe = 51
G.Y_Horseshoe = {[0] = 0.0, 0.04146, 0.07033, 0.09098, 0.10962, 0.12921, 0.14813, 0.16701, 0.18565, 0.20401, 0.22211, 0.23998, 0.25769, 0.27524, 0.29265, 0.3099, 0.32704, 0.34406, 0.36101, 0.3779, 0.39471, 0.41147, 0.42818, 0.44484, 0.46147, 0.47807, 0.49468, 0.51134, 0.52803, 0.54474, 0.56138, 0.57804, 0.59478, 0.61171, 0.62881, 0.64609, 0.6635, 0.68111, 0.69901, 0.71722, 0.73583, 0.7549, 0.77447, 0.79471, 0.81564, 0.83759, 0.86067, 0.88557, 0.91159, 0.9452, 1.0}
G.N_S_Horseshoe = 51
G.S_Horseshoe = {[0] = 0.0, 0.00467, 0.01237, 0.02268, 0.03515, 0.04943, 0.06525, 0.08212, 0.10005, 0.11891, 0.13856, 0.15896, 0.18004, 0.20172, 0.22397, 0.24677, 0.27006, 0.2938, 0.3179, 0.34237, 0.3672, 0.39239, 0.41792, 0.44374, 0.46984, 0.49619, 0.52276, 0.5495, 0.5764, 0.60345, 0.63065, 0.65795, 0.68531, 0.71271, 0.74009, 0.76738, 0.79451, 0.82144, 0.84814, 0.8745, 0.90057, 0.92652, 0.95244, 0.97724, 0.99988, 1.02048, 1.03989, 1.05698, 1.07694, 1.07562, 1.0}
G.N_W_Horseshoe = 26
G.W_Horseshoe = {[0] = 0.0, 0.5878, 0.8772, 0.89, 0.9028, 0.9156, 0.9284, 0.9412, 0.954, 0.9668, 0.9798, 0.9928, 0.9992, 0.9992, 0.9928, 0.9798, 0.96, 0.933, 0.898, 0.8542, 0.8, 0.7332, 0.6499, 0.5426, 0.3919, 0.0}
G.N_Y_Gothic = 51
G.Y_Gothic = {[0] = 0.0, 0.04522, 0.07825, 0.10646, 0.12645, 0.14645, 0.16787, 0.18641, 0.20129, 0.22425, 0.24129, 0.25624, 0.27344, 0.29097, 0.30529, 0.32607, 0.33755, 0.35073, 0.36447, 0.37558, 0.4, 0.4181, 0.43648, 0.45374, 0.46805, 0.48195, 0.49626, 0.51352, 0.5319, 0.55, 0.56416, 0.57787, 0.59224, 0.6095, 0.62941, 0.65, 0.67064, 0.69055, 0.70721, 0.72031, 0.73286, 0.74632, 0.76432, 0.78448, 0.80421, 0.82199, 0.84363, 0.87423, 0.90617, 0.93827, 1.0}
G.N_S_Gothic = 51
G.S_Gothic = {[0] = 0.0, 0.005, 0.0174, 0.03098, 0.04272, 0.055, 0.0698, 0.0862, 0.10461, 0.12463, 0.145, 0.16309, 0.18118, 0.2, 0.22181, 0.24487, 0.26888, 0.2938, 0.31901, 0.34389, 0.36564, 0.38612, 0.4072, 0.43, 0.45868, 0.48895, 0.52, 0.55032, 0.5804, 0.61, 0.63762, 0.66505, 0.6929, 0.72342, 0.75467, 0.785, 0.81165, 0.83654, 0.86, 0.88253, 0.90414, 0.925, 0.94486, 0.96475, 0.98567, 1.00833, 1.03, 1.0536, 1.065, 1.055, 1.0}
G.N_W_Gothic = 21
G.W_Gothic = {[0] = 0.0, 0.286, 0.643, 0.762, 0.833, 0.905, 0.952, 0.976, 0.976, 1.0, 1.0, 0.976, 0.976, 0.952, 0.905, 0.833, 0.762, 0.667, 0.524, 0.357, 0.0}
G.N_Y_Catenary = 51
G.Y_Catenary = {[0] = 0.0, 0.02974, 0.06439, 0.08433, 0.10549, 0.12064, 0.13952, 0.1556, 0.17032, 0.18512, 0.20057, 0.21995, 0.24011, 0.25892, 0.27595, 0.29214, 0.30802, 0.32372, 0.33894, 0.35315, 0.36557, 0.37833, 0.3923, 0.4097, 0.42982, 0.45, 0.46769, 0.48431, 0.5, 0.51466, 0.52886, 0.54292, 0.55729, 0.57223, 0.5878, 0.60428, 0.62197, 0.64047, 0.6598, 0.67976, 0.7, 0.71731, 0.73769, 0.76651, 0.8, 0.8209, 0.84311, 0.87978, 0.91576, 0.95, 1.0}
G.N_S_Catenary = 51
G.S_Catenary = {[0] = 0.0, 0.00605, 0.01455, 0.0254, 0.03863, 0.0543, 0.07127, 0.08778, 0.10372, 0.12081, 0.14082, 0.16375, 0.18779, 0.21157, 0.23478, 0.25818, 0.28244, 0.30741, 0.33204, 0.35505, 0.37465, 0.39404, 0.41426, 0.43804, 0.46531, 0.49357, 0.52187, 0.54925, 0.57647, 0.60321, 0.62964, 0.65639, 0.68472, 0.71425, 0.74303, 0.76827, 0.79168, 0.815, 0.84094, 0.86707, 0.89213, 0.91607, 0.94, 0.96604, 0.99, 1.00714, 1.02158, 1.03814, 1.05, 1.05, 1.0}
G.N_W_Catenary = 21
G.W_Catenary = {[0] = 0.0, 0.6667, 0.8222, 0.9111, 0.9778, 1.0, 1.0, 0.9889, 0.9778, 0.9556, 0.9333, 0.8889, 0.8444, 0.8, 0.7556, 0.7, 0.6333, 0.5556, 0.4444, 0.3333, 0.0}
G.N_Y_SemiEllip = 51
G.Y_SemiEllip = {[0] = 0.0, 0.03075, 0.05137, 0.07032, 0.09, 0.11323, 0.13037, 0.14519, 0.15968, 0.18459, 0.19531, 0.21354, 0.22694, 0.23947, 0.25296, 0.265, 0.27784, 0.29212, 0.3097, 0.32982, 0.35, 0.36738, 0.3839, 0.4, 0.41667, 0.43333, 0.45, 0.46697, 0.48372, 0.5, 0.51374, 0.52747, 0.54209, 0.5595, 0.57941, 0.6, 0.62, 0.64, 0.66, 0.68, 0.7, 0.71843, 0.73865, 0.76365, 0.7926, 0.82088, 0.85, 0.88341, 0.90998, 0.93871, 1.0}
G.N_S_SemiEllip = 51
G.S_SemiEllip = {[0] = 0.0, 0.00438, 0.01227, 0.02312, 0.03638, 0.05145, 0.06783, 0.085, 0.10093, 0.11752, 0.1353, 0.15626, 0.17917, 0.20296, 0.22654, 0.24962, 0.27269, 0.29568, 0.31848, 0.34152, 0.365, 0.38941, 0.41442, 0.44, 0.46636, 0.49309, 0.52, 0.54628, 0.57285, 0.6, 0.62949, 0.65877, 0.68624, 0.71017, 0.73304, 0.75578, 0.77925, 0.80368, 0.83114, 0.8595, 0.88592, 0.90848, 0.93, 0.95292, 0.97481, 0.99374, 1.01084, 1.02858, 1.04543, 1.05, 1.0}
G.N_W_SemiEllip = 21
G.W_SemiEllip = {[0] = 0.0, 0.7, 0.98, 1.0, 1.0, 1.0, 0.99, 0.98, 0.96, 0.94, 0.91, 0.88, 0.84, 0.8, 0.75, 0.7, 0.64, 0.56, 0.46, 0.34, 0.0}
G.N_A_Baskethandle = 26
G.A_Baskethandle = {[0] = 0.0, 0.0173, 0.0457, 0.0828, 0.1271, 0.1765, 0.227, 0.2775, 0.328, 0.378, 0.427, 0.4765, 0.526, 0.574, 0.622, 0.669, 0.716, 0.761, 0.803, 0.839, 0.877, 0.911, 0.941, 0.968, 0.988, 1.0}
G.N_R_Baskethandle = 26
G.R_Baskethandle = {[0] = 0.01, 0.0952, 0.189, 0.273, 0.369, 0.463, 0.56, 0.653, 0.743, 0.822, 0.883, 0.949, 0.999, 1.055, 1.095, 1.141, 1.161, 1.188, 1.206, 1.206, 1.206, 1.205, 1.196, 1.168, 1.127, 1.0}
G.N_Y_BasketHandle = 51
G.Y_BasketHandle = {[0] = 0.0, 0.04112, 0.0738, 0.1, 0.12236, 0.14141, 0.15857, 0.17462, 0.18946, 0.20315, 0.21557, 0.22833, 0.2423, 0.25945, 0.27936, 0.3, 0.3204, 0.34034, 0.35892, 0.37595, 0.39214, 0.40802, 0.42372, 0.43894, 0.45315, 0.46557, 0.47833, 0.4923, 0.50945, 0.52936, 0.55, 0.57, 0.59, 0.61023, 0.63045, 0.65, 0.66756, 0.68413, 0.7, 0.71481, 0.72984, 0.74579, 0.76417, 0.78422, 0.80477, 0.82532, 0.85, 0.88277, 0.915, 0.95, 1.0}
G.N_S_BasketHandle = 51
G.S_BasketHandle = {[0] = 0.0, 0.00758, 0.01812, 0.03, 0.03966, 0.04957, 0.0623, 0.07849, 0.09618, 0.11416, 0.13094, 0.14808, 0.16583, 0.18381, 0.20294, 0.225, 0.2547, 0.28532, 0.31006, 0.32804, 0.34555, 0.36944, 0.40032, 0.43203, 0.46004, 0.47849, 0.49591, 0.51454, 0.5381, 0.56711, 0.6, 0.64092, 0.68136, 0.71259, 0.73438, 0.755, 0.78625, 0.8188, 0.85, 0.8679, 0.88483, 0.90431, 0.9369, 0.97388, 1.00747, 1.033, 1.05, 1.05464, 1.06078, 1.055, 1.0}
G.N_W_BasketHandle = 26
G.W_BasketHandle = {[0] = 0.0, 0.49, 0.667, 0.82, 0.93, 1.0, 1.0, 1.0, 0.997, 0.994, 0.988, 0.982, 0.967, 0.948, 0.928, 0.904, 0.874, 0.842, 0.798, 0.75, 0.697, 0.637, 0.567, 0.467, 0.342, 0.0}
G.N_Y_SemiCirc = 51
G.Y_SemiCirc = {[0] = 0.0, 0.04102, 0.07407, 0.1, 0.11769, 0.13037, 0.14036, 0.15, 0.16546, 0.18213, 0.2, 0.22018, 0.2403, 0.25788, 0.27216, 0.285, 0.29704, 0.30892, 0.32128, 0.33476, 0.35, 0.36927, 0.38963, 0.41023, 0.43045, 0.45, 0.46769, 0.48431, 0.5, 0.51443, 0.52851, 0.54271, 0.55774, 0.57388, 0.59101, 0.60989, 0.63005, 0.65, 0.66682, 0.68318, 0.7, 0.71675, 0.73744, 0.76651, 0.8, 0.8209, 0.84311, 0.87978, 0.91576, 0.95, 1.0}
G.N_S_SemiCirc = 51
G.S_SemiCirc = {[0] = 0.0, 0.00757, 0.01815, 0.03, 0.0358, 0.04037, 0.04601, 0.055, 0.07475, 0.09834, 0.125, 0.1557, 0.18588, 0.20883, 0.223, 0.23472, 0.24667, 0.26758, 0.29346, 0.32124, 0.35, 0.3772, 0.4054, 0.43541, 0.46722, 0.5, 0.53532, 0.56935, 0.6, 0.61544, 0.62811, 0.6417, 0.66598, 0.7001, 0.73413, 0.76068, 0.78027, 0.8, 0.82891, 0.85964, 0.89, 0.9127, 0.93664, 0.96677, 1.0, 1.02661, 1.04631, 1.05726, 1.06637, 1.06, 1.0}
G.N_W_SemiCirc = 21
G.W_SemiCirc = {[0] = 0.0, 0.5488, 0.8537, 1.0, 1.0, 0.9939, 0.9878, 0.9756, 0.9634, 0.9451, 0.9207, 0.8902, 0.8537, 0.8171, 0.7683, 0.7073, 0.6463, 0.5732, 0.4756, 0.3354, 0.0}
G.NumCodesEllipse = 23
G.MinorAxis_Ellipse = {[0] = 14.0, 19.0, 22.0, 24.0, 27.0, 29.0, 32.0, 34.0, 38.0, 43.0, 48.0, 53.0, 58.0, 63.0, 68.0, 72.0, 77.0, 82.0, 87.0, 92.0, 97.0, 106.0, 116.0}
G.MajorAxis_Ellipse = {[0] = 23.0, 30.0, 34.0, 38.0, 42.0, 45.0, 49.0, 53.0, 60.0, 68.0, 76.0, 83.0, 91.0, 98.0, 106.0, 113.0, 121.0, 128.0, 136.0, 143.0, 151.0, 166.0, 180.0}
G.Afull_Ellipse = {[0] = 1.8, 3.3, 4.1, 5.1, 6.3, 7.4, 8.8, 10.2, 12.9, 16.6, 20.5, 24.8, 29.5, 34.6, 40.1, 46.1, 52.4, 59.2, 66.4, 74.0, 82.0, 99.2, 118.6}
G.Rfull_Ellipse = {[0] = 0.367, 0.49, 0.546, 0.613, 0.686, 0.736, 0.812, 0.875, 0.969, 1.106, 1.229, 1.352, 1.475, 1.598, 1.721, 1.845, 1.967, 2.091, 2.215, 2.34, 2.461, 2.707, 2.968}
G.N_A_HorizEllipse = 26
G.A_HorizEllipse = {[0] = 0.0, 0.015, 0.04, 0.065, 0.095, 0.13, 0.165, 0.205, 0.25, 0.3, 0.355, 0.415, 0.48, 0.52, 0.585, 0.645, 0.7, 0.75, 0.795, 0.835, 0.87, 0.905, 0.935, 0.96, 0.985, 1.0}
G.N_R_HorizEllipse = 26
G.R_HorizEllipse = {[0] = 0.01, 0.0764, 0.1726, 0.2389, 0.3274, 0.4191, 0.512, 0.5983, 0.6757, 0.763, 0.8326, 0.9114, 0.9702, 1.03, 1.091, 1.146, 1.185, 1.225, 1.257, 1.274, 1.29, 1.282, 1.274, 1.257, 1.185, 1.0}
G.N_W_HorizEllipse = 26
G.W_HorizEllipse = {[0] = 0.0, 0.3919, 0.5426, 0.6499, 0.7332, 0.8, 0.8542, 0.898, 0.933, 0.96, 0.9798, 0.9928, 0.9992, 0.9992, 0.9928, 0.9798, 0.96, 0.933, 0.898, 0.8542, 0.8, 0.7332, 0.6499, 0.5426, 0.3919, 0.0}
G.N_A_VertEllipse = 26
G.A_VertEllipse = {[0] = 0.0, 0.01, 0.04, 0.07, 0.1, 0.14, 0.185, 0.23, 0.28, 0.33, 0.38, 0.43, 0.48, 0.52, 0.57, 0.62, 0.67, 0.72, 0.77, 0.815, 0.86, 0.9, 0.93, 0.96, 0.99, 1.0}
G.N_R_VertEllipse = 26
G.R_VertEllipse = {[0] = 0.01, 0.125, 0.2436, 0.3536, 0.4474, 0.5484, 0.6366, 0.7155, 0.7768, 0.8396, 0.8969, 0.948, 0.9925, 1.023, 1.053, 1.084, 1.107, 1.13, 1.154, 1.17, 1.177, 1.177, 1.17, 1.162, 1.122, 1.0}
G.N_W_VertEllipse = 26
G.W_VertEllipse = {[0] = 0.0, 0.3919, 0.5426, 0.6499, 0.7332, 0.8, 0.8542, 0.898, 0.933, 0.96, 0.9798, 0.9928, 0.9992, 0.9992, 0.9928, 0.9798, 0.96, 0.933, 0.898, 0.8542, 0.8, 0.7332, 0.6499, 0.5426, 0.3919, 0.0}
G.NumCodesArch = 102
G.Yfull_Arch = {[0] = 11.0, 13.5, 15.5, 18.0, 22.5, 26.625, 31.3125, 36.0, 40.0, 45.0, 54.0, 62.0, 72.0, 77.5, 87.125, 96.875, 106.5, 13.0, 15.0, 18.0, 20.0, 24.0, 29.0, 33.0, 38.0, 43.0, 47.0, 52.0, 57.0, 31.0, 36.0, 41.0, 46.0, 51.0, 55.0, 59.0, 63.0, 67.0, 71.0, 75.0, 79.0, 83.0, 87.0, 91.0, 55.0, 57.0, 59.0, 61.0, 63.0, 65.0, 67.0, 69.0, 71.0, 73.0, 75.0, 77.0, 79.0, 81.0, 83.0, 85.0, 87.0, 89.0, 91.0, 93.0, 95.0, 97.0, 100.0, 101.0, 103.0, 105.0, 107.0, 109.0, 111.0, 113.0, 115.0, 118.0, 119.0, 121.0, 112.0, 114.0, 116.0, 118.0, 120.0, 122.0, 124.0, 126.0, 128.0, 130.0, 132.0, 134.0, 136.0, 138.0, 140.0, 142.0, 144.0, 146.0, 148.0, 150.0, 152.0, 154.0, 156.0, 158.0}
G.Wmax_Arch = {[0] = 18.0, 22.0, 26.0, 28.5, 36.25, 43.75, 51.125, 58.5, 65.0, 73.0, 88.0, 102.0, 115.0, 122.0, 138.0, 154.0, 168.75, 17.0, 21.0, 24.0, 28.0, 35.0, 42.0, 49.0, 57.0, 64.0, 71.0, 77.0, 83.0, 40.0, 46.0, 53.0, 60.0, 66.0, 73.0, 81.0, 87.0, 95.0, 103.0, 112.0, 117.0, 128.0, 137.0, 142.0, 73.0, 76.0, 81.0, 84.0, 87.0, 92.0, 95.0, 98.0, 103.0, 106.0, 112.0, 114.0, 117.0, 123.0, 128.0, 131.0, 137.0, 139.0, 142.0, 148.0, 150.0, 152.0, 154.0, 161.0, 167.0, 169.0, 171.0, 178.0, 184.0, 186.0, 188.0, 190.0, 197.0, 199.0, 159.0, 162.0, 168.0, 170.0, 173.0, 179.0, 184.0, 187.0, 190.0, 195.0, 198.0, 204.0, 206.0, 209.0, 215.0, 217.0, 223.0, 225.0, 231.0, 234.0, 236.0, 239.0, 245.0, 247.0}
G.Afull_Arch = {[0] = 1.1, 1.65, 2.2, 2.8, 4.4, 6.4, 8.8, 11.4, 14.3, 17.7, 25.6, 34.6, 44.5, 51.7, 66.0, 81.8, 99.1, 1.1, 1.6, 2.2, 2.9, 4.5, 6.5, 8.9, 11.6, 14.7, 18.1, 21.9, 26.0, 7.0, 9.4, 12.3, 15.6, 19.3, 23.2, 27.4, 32.1, 37.0, 42.4, 48.0, 54.2, 60.5, 67.4, 74.5, 22.0, 24.0, 26.0, 28.0, 31.0, 33.0, 35.0, 38.0, 40.0, 43.0, 46.0, 49.0, 52.0, 55.0, 58.0, 61.0, 64.0, 67.0, 71.0, 74.0, 78.0, 81.0, 85.0, 89.0, 93.0, 97.0, 101.0, 105.0, 109.0, 113.0, 118.0, 122.0, 126.0, 131.0, 97.0, 102.0, 105.0, 109.0, 114.0, 118.0, 123.0, 127.0, 132.0, 137.0, 142.0, 146.0, 151.0, 157.0, 161.0, 167.0, 172.0, 177.0, 182.0, 188.0, 194.0, 200.0, 205.0, 211.0}
G.Rfull_Arch = {[0] = 0.25, 0.3, 0.36, 0.45, 0.56, 0.68, 0.8, 0.9, 1.01, 1.13, 1.35, 1.57, 1.77, 1.92, 2.17, 2.42, 2.65, 0.324, 0.374, 0.449, 0.499, 0.598, 0.723, 0.823, 0.947, 1.072, 1.171, 1.296, 1.421, 0.773, 0.773, 1.022, 1.147, 1.271, 1.371, 1.471, 1.57, 1.67, 1.77, 1.869, 1.969, 2.069, 2.168, 2.268, 1.371, 1.421, 1.471, 1.52, 1.57, 1.62, 1.67, 1.72, 1.77, 1.82, 1.869, 1.919, 1.969, 2.019, 2.069, 2.119, 2.168, 2.218, 2.268, 2.318, 2.368, 2.418, 2.493, 2.517, 2.567, 2.617, 2.667, 2.717, 2.767, 2.817, 2.866, 2.941, 2.966, 3.016, 2.792, 2.841, 2.891, 2.941, 2.991, 3.041, 3.091, 3.141, 3.19, 3.24, 3.29, 3.34, 3.39, 3.44, 3.49, 3.539, 3.589, 3.639, 3.689, 3.739, 3.789, 3.838, 3.888, 3.938}
G.N_A_Arch = 26
G.A_Arch = {[0] = 0.0, 0.02, 0.06, 0.1, 0.14, 0.19, 0.24, 0.29, 0.34, 0.39, 0.44, 0.49, 0.54, 0.59, 0.64, 0.69, 0.735, 0.78, 0.82, 0.86, 0.895, 0.93, 0.96, 0.985, 0.995, 1.0}
G.N_R_Arch = 26
G.R_Arch = {[0] = 0.01, 0.0983, 0.1965, 0.2948, 0.394, 0.4962, 0.5911, 0.6796, 0.7615, 0.8364, 0.9044, 0.964, 1.018, 1.065, 1.106, 1.142, 1.17, 1.192, 1.208, 1.217, 1.22, 1.213, 1.196, 1.168, 1.112, 1.0}
G.N_W_Arch = 26
G.W_Arch = {[0] = 0.0, 0.6272, 0.8521, 0.9243, 0.9645, 0.9846, 0.9964, 0.9988, 0.9917, 0.9811, 0.968, 0.9515, 0.9314, 0.9101, 0.8864, 0.8592, 0.8284, 0.7917, 0.7527, 0.7065, 0.6544, 0.5953, 0.5231, 0.4355, 0.3195, 0.0}
G.Amax = {[0] = 1.0, 0.9756, 0.9756, 0.97, 1.0, 1.0, 1.0, 1.0, 1.0, 0.98, 0.98, 0.96, 0.96, 0.96, 0.92, 0.96, 0.96, 0.96, 0.98, 0.98, 0.96, 0.96, 1.0, 0.96, 0.9756, 1.0}

-- xsect.c:204
F.xsect_isOpen = function(type_)
  do return ((((G.Amax[type_] >= 1.0)) and 1 or 0)) end
end

-- xsect.c:216
F.xsect_setParams = function(xsect, type_, p, ucf)
  local G_MinorAxis_Ellipse, G_MajorAxis_Ellipse, G_Afull_Ellipse, G_Rfull_Ellipse = G.MinorAxis_Ellipse, G.MajorAxis_Ellipse, G.Afull_Ellipse, G.Rfull_Ellipse
  local index = 0
  local aMax = 0.0
  local theta = 0.0
  if ((type_ ~= DUMMY) and (p[0] <= 0.0)) then
    do return 0 end
  end
  xsect.type_ = type_
  do
    local __sw1 = xsect.type_
    if __sw1 < MOD_BASKET then
      if __sw1 < TRAPEZOIDAL then
        if __sw1 < FILLED_CIRCULAR then
          if __sw1 == DUMMY then goto case2
          elseif __sw1 == CIRCULAR then goto case3
          end
        else
          if __sw1 == FILLED_CIRCULAR then goto case5
          elseif __sw1 == RECT_CLOSED then goto case13
          elseif __sw1 == RECT_OPEN then goto case14
          end
        end
      else
        if __sw1 < POWERFUNC then
          if __sw1 == TRAPEZOIDAL then goto case18
          elseif __sw1 == TRIANGULAR then goto case19
          elseif __sw1 == PARABOLIC then goto case20
          end
        else
          if __sw1 == POWERFUNC then goto case21
          elseif __sw1 == RECT_TRIANG then goto case15
          elseif __sw1 == RECT_ROUND then goto case16
          end
        end
      end
    else
      if __sw1 < GOTHIC then
        if __sw1 < ARCH then
          if __sw1 == MOD_BASKET then goto case17
          elseif __sw1 == HORIZ_ELLIPSE then goto case22
          elseif __sw1 == VERT_ELLIPSE then goto case23
          end
        else
          if __sw1 == ARCH then goto case24
          elseif __sw1 == EGGSHAPED then goto case6
          elseif __sw1 == HORSESHOE then goto case7
          end
        end
      else
        if __sw1 < BASKETHANDLE then
          if __sw1 == GOTHIC then goto case8
          elseif __sw1 == CATENARY then goto case9
          elseif __sw1 == SEMIELLIPTICAL then goto case10
          end
        else
          if __sw1 == BASKETHANDLE then goto case11
          elseif __sw1 == SEMICIRCULAR then goto case12
          elseif __sw1 == FORCE_MAIN then goto case4
          end
        end
      end
    end
    goto swend1
    ::case2::
    do
      xsect.yFull = 1e-06
      xsect.wMax = 1e-06
      xsect.aFull = 1e-06
      xsect.rFull = 1e-06
      xsect.sFull = 1e-06
      xsect.sMax = 1e-06
      goto swend1
    end
    ::case3::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = xsect.yFull
      xsect.aFull = (((3.141592654 / 4.0) * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.25 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.08 * xsect.sFull)
      xsect.ywMax = (0.5 * xsect.yFull)
      goto swend1
    end
    ::case4::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = xsect.yFull
      xsect.aFull = (((3.141592654 / 4.0) * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.25 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ 0.63))
      xsect.sMax = (1.06949 * xsect.sFull)
      xsect.ywMax = (0.5 * xsect.yFull)
      xsect.rBot = p[1]
      goto swend1
    end
    ::case5::
    do
      if (p[1] >= p[0]) then
        do return 0 end
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = xsect.yFull
      xsect.aFull = (((3.141592654 / 4.0) * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.25 * xsect.yFull)
      xsect.yBot = (p[1] / ucf)
      xsect.aBot = F.circ_getAofY(xsect, xsect.yBot)
      xsect.sBot = F.xsect_getWofY(xsect, xsect.yBot)
      xsect.rBot = (xsect.aBot / ((xsect.rFull * F.lookup((xsect.yBot / xsect.yFull), G.R_Circ, G.N_R_Circ))))
      xsect.aFull = (xsect.aFull - xsect.aBot)
      xsect.rFull = (xsect.aFull / ((((3.141592654 * xsect.yFull) - xsect.rBot) + xsect.sBot)))
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.08 * xsect.sFull)
      xsect.yFull = (xsect.yFull - xsect.yBot)
      xsect.ywMax = (0.5 * xsect.yFull)
      goto swend1
    end
    ::case6::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.aFull = ((0.5105 * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.1931 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.065 * xsect.sFull)
      xsect.wMax = ((2.0 / 3.0) * xsect.yFull)
      xsect.ywMax = (0.64 * xsect.yFull)
      goto swend1
    end
    ::case7::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.aFull = ((0.8293 * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.2538 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.077 * xsect.sFull)
      xsect.wMax = (1.0 * xsect.yFull)
      xsect.ywMax = (0.5 * xsect.yFull)
      goto swend1
    end
    ::case8::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.aFull = ((0.6554 * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.2269 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.065 * xsect.sFull)
      xsect.wMax = (0.84 * xsect.yFull)
      xsect.ywMax = (0.45 * xsect.yFull)
      goto swend1
    end
    ::case9::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.aFull = ((0.70277 * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.23172 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.05 * xsect.sFull)
      xsect.wMax = (0.9 * xsect.yFull)
      xsect.ywMax = (0.25 * xsect.yFull)
      goto swend1
    end
    ::case10::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.aFull = ((0.785 * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.242 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.045 * xsect.sFull)
      xsect.wMax = (1.0 * xsect.yFull)
      xsect.ywMax = (0.15 * xsect.yFull)
      goto swend1
    end
    ::case11::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.aFull = ((0.7862 * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.2464 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.06078 * xsect.sFull)
      xsect.wMax = (0.944 * xsect.yFull)
      xsect.ywMax = (0.2 * xsect.yFull)
      goto swend1
    end
    ::case12::
    do
      xsect.yFull = (p[0] / ucf)
      xsect.aFull = ((1.2697 * xsect.yFull) * xsect.yFull)
      xsect.rFull = (0.2946 * xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = (1.06637 * xsect.sFull)
      xsect.wMax = (1.64 * xsect.yFull)
      xsect.ywMax = (0.15 * xsect.yFull)
      goto swend1
    end
    ::case13::
    do
      if (p[1] <= 0.0) then
        do return 0 end
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = (p[1] / ucf)
      xsect.aFull = (xsect.yFull * xsect.wMax)
      xsect.rFull = (xsect.aFull / ((2.0 * ((xsect.yFull + xsect.wMax)))))
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      aMax = (0.97 * xsect.aFull)
      xsect.sMax = (aMax * ((F.rect_closed_getRofA(xsect, aMax)) ^ (2.0 / 3.0)))
      xsect.ywMax = xsect.yFull
      goto swend1
    end
    ::case14::
    do
      if (p[1] <= 0.0) then
        do return 0 end
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = (p[1] / ucf)
      if ((p[2] < 0.0) or (p[2] > 2.0)) then
        do return 0 end
      end
      xsect.sBot = p[2]
      xsect.aFull = (xsect.yFull * xsect.wMax)
      xsect.rFull = (xsect.aFull / (((((2.0 - xsect.sBot)) * xsect.yFull) + xsect.wMax)))
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = xsect.sFull
      xsect.ywMax = xsect.yFull
      goto swend1
    end
    ::case15::
    do
      if ((p[1] <= 0.0) or (p[2] <= 0.0)) then
        do return 0 end
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = (p[1] / ucf)
      xsect.yBot = (p[2] / ucf)
      xsect.ywMax = xsect.yFull
      xsect.aBot = ((xsect.yBot * xsect.wMax) / 2.0)
      xsect.sBot = ((xsect.wMax / xsect.yBot) / 2.0)
      xsect.rBot = m_sqrt((1.0 + (xsect.sBot * xsect.sBot)))
      xsect.aFull = (xsect.wMax * ((xsect.yFull - (xsect.yBot / 2.0))))
      xsect.rFull = (xsect.aFull / (((((2.0 * xsect.yBot) * xsect.rBot) + (2.0 * ((xsect.yFull - xsect.yBot)))) + xsect.wMax)))
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      aMax = (0.98 * xsect.aFull)
      xsect.sMax = (aMax * ((F.rect_triang_getRofA(xsect, aMax)) ^ (2.0 / 3.0)))
      goto swend1
    end
    ::case16::
    do
      if (p[1] <= 0.0) then
        do return 0 end
      end
      if (p[2] < (p[1] / 2.0)) then
        p[2] = (p[1] / 2.0)
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = (p[1] / ucf)
      xsect.rBot = (p[2] / ucf)
      theta = (2.0 * m_asin(((xsect.wMax / 2.0) / xsect.rBot)))
      xsect.aBot = (((xsect.rBot * xsect.rBot) / 2.0) * ((theta - m_sin(theta))))
      xsect.sBot = (((3.141592654 * xsect.rBot) * xsect.rBot) * ((xsect.rBot / 2.0) ^ (2.0 / 3.0)))
      xsect.yBot = (xsect.rBot * ((1.0 - m_cos((theta / 2.0)))))
      if (xsect.yBot > xsect.yFull) then
        do return 0 end
      end
      xsect.ywMax = xsect.yFull
      xsect.aFull = ((xsect.wMax * ((xsect.yFull - xsect.yBot))) + xsect.aBot)
      xsect.rFull = (xsect.aFull / ((((xsect.rBot * theta) + (2.0 * ((xsect.yFull - xsect.yBot)))) + xsect.wMax)))
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      aMax = (0.98 * xsect.aFull)
      xsect.sMax = (aMax * ((F.rect_round_getRofA(xsect, aMax)) ^ (2.0 / 3.0)))
      goto swend1
    end
    ::case17::
    do
      if (p[1] <= 0.0) then
        do return 0 end
      end
      if (p[2] < (p[1] / 2.0)) then
        p[2] = (p[1] / 2.0)
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = (p[1] / ucf)
      xsect.rBot = (p[2] / ucf)
      theta = (2.0 * m_asin(((xsect.wMax / 2.0) / xsect.rBot)))
      xsect.sBot = theta
      xsect.yBot = (xsect.rBot * ((1.0 - m_cos((theta / 2.0)))))
      if (xsect.yBot > xsect.yFull) then
        do return 0 end
      end
      xsect.ywMax = (xsect.yFull - xsect.yBot)
      xsect.aBot = (((xsect.rBot * xsect.rBot) / 2.0) * ((theta - m_sin(theta))))
      xsect.aFull = ((((xsect.yFull - xsect.yBot)) * xsect.wMax) + xsect.aBot)
      xsect.rFull = (xsect.aFull / ((((xsect.rBot * theta) + (2.0 * ((xsect.yFull - xsect.yBot)))) + xsect.wMax)))
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = F.xsect_getSofA(xsect, (G.Amax[MOD_BASKET] * xsect.aFull))
      goto swend1
    end
    ::case18::
    do
      if (((p[1] < 0.0) or (p[2] < 0.0)) or (p[3] < 0.0)) then
        do return 0 end
      end
      xsect.yFull = (p[0] / ucf)
      xsect.ywMax = xsect.yFull
      xsect.yBot = (p[1] / ucf)
      xsect.sBot = (((p[2] + p[3])) / 2.0)
      if ((xsect.yBot == 0.0) and (xsect.sBot == 0.0)) then
        do return 0 end
      end
      xsect.rBot = (m_sqrt((1.0 + (p[2] * p[2]))) + m_sqrt((1.0 + (p[3] * p[3]))))
      xsect.wMax = (xsect.yBot + (xsect.yFull * ((p[2] + p[3]))))
      xsect.aFull = (((xsect.yBot + (xsect.sBot * xsect.yFull))) * xsect.yFull)
      xsect.rFull = (xsect.aFull / ((xsect.yBot + (xsect.yFull * xsect.rBot))))
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = xsect.sFull
      goto swend1
    end
    ::case19::
    do
      if (p[1] <= 0.0) then
        do return 0 end
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = (p[1] / ucf)
      xsect.ywMax = xsect.yFull
      xsect.sBot = ((xsect.wMax / xsect.yFull) / 2.0)
      xsect.rBot = m_sqrt((1.0 + (xsect.sBot * xsect.sBot)))
      xsect.aFull = ((xsect.yFull * xsect.yFull) * xsect.sBot)
      xsect.rFull = (xsect.aFull / (((2.0 * xsect.yFull) * xsect.rBot)))
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = xsect.sFull
      goto swend1
    end
    ::case20::
    do
      if (p[1] <= 0.0) then
        do return 0 end
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = (p[1] / ucf)
      xsect.ywMax = xsect.yFull
      xsect.rBot = ((xsect.wMax / 2.0) / m_sqrt(xsect.yFull))
      xsect.aFull = ((((2.0 / 3.0)) * xsect.yFull) * xsect.wMax)
      xsect.rFull = F.xsect_getRofY(xsect, xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = xsect.sFull
      goto swend1
    end
    ::case21::
    do
      if ((p[1] <= 0.0) or (p[2] <= 0.0)) then
        do return 0 end
      end
      xsect.yFull = (p[0] / ucf)
      xsect.wMax = (p[1] / ucf)
      xsect.ywMax = xsect.yFull
      xsect.sBot = (1.0 / p[2])
      xsect.rBot = ((xsect.wMax / ((xsect.sBot + 1.0))) / R.pow(xsect.yFull, xsect.sBot))
      xsect.aFull = ((xsect.yFull * xsect.wMax) / ((xsect.sBot + 1.0)))
      xsect.rFull = F.xsect_getRofY(xsect, xsect.yFull)
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = xsect.sFull
      goto swend1
    end
    ::case22::
    do
      if (p[1] == 0.0) then
        p[2] = p[0]
      end
      if (p[2] > 0.0) then
        index = (R.D2I(R.floor(p[2])) - 1)
        if ((index < 0) or (index >= G.NumCodesEllipse)) then
          do return 0 end
        end
        xsect.yFull = (G_MinorAxis_Ellipse[index] / 12.0)
        xsect.wMax = (G_MajorAxis_Ellipse[index] / 12.0)
        xsect.aFull = G_Afull_Ellipse[index]
        xsect.rFull = G_Rfull_Ellipse[index]
      else
        xsect.yFull = (p[0] / ucf)
        if (p[1] < 0.0) then
          do return 0 end
        end
        xsect.wMax = (p[1] / ucf)
        xsect.aFull = ((1.2692 * xsect.yFull) * xsect.yFull)
        xsect.rFull = (0.3061 * xsect.yFull)
      end
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = xsect.sFull
      xsect.ywMax = (0.48 * xsect.yFull)
      goto swend1
    end
    ::case23::
    do
      if (p[1] == 0.0) then
        p[2] = p[0]
      end
      if (p[2] > 0.0) then
        index = (R.D2I(R.floor(p[2])) - 1)
        if ((index < 0) or (index >= G.NumCodesEllipse)) then
          do return 0 end
        end
        xsect.yFull = (G_MajorAxis_Ellipse[index] / 12.0)
        xsect.wMax = (G_MinorAxis_Ellipse[index] / 12.0)
        xsect.aFull = G_Afull_Ellipse[index]
        xsect.rFull = G_Rfull_Ellipse[index]
      else
        if (p[1] < 0.0) then
          do return 0 end
        end
        xsect.yFull = (p[0] / ucf)
        xsect.wMax = (p[1] / ucf)
        xsect.aFull = ((1.2692 * xsect.wMax) * xsect.wMax)
        xsect.rFull = (0.3061 * xsect.wMax)
      end
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = xsect.sFull
      xsect.ywMax = (0.48 * xsect.yFull)
      goto swend1
    end
    ::case24::
    do
      if (p[1] == 0.0) then
        p[2] = p[0]
      end
      if (p[2] > 0.0) then
        index = (R.D2I(R.floor(p[2])) - 1)
        if ((index < 0) or (index >= G.NumCodesArch)) then
          do return 0 end
        end
        xsect.yFull = (G.Yfull_Arch[index] / 12.0)
        xsect.wMax = (G.Wmax_Arch[index] / 12.0)
        xsect.aFull = G.Afull_Arch[index]
        xsect.rFull = G.Rfull_Arch[index]
      else
        if (p[1] < 0.0) then
          do return 0 end
        end
        xsect.yFull = (p[0] / ucf)
        xsect.wMax = (p[1] / ucf)
        xsect.aFull = ((0.7879 * xsect.yFull) * xsect.wMax)
        xsect.rFull = (0.2991 * xsect.yFull)
      end
      xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
      xsect.sMax = xsect.sFull
      xsect.ywMax = (0.28 * xsect.yFull)
      goto swend1
    end
    ::swend1::
  end
  do return 1 end
end

-- xsect.c:638
F.xsect_setIrregXsectParams = function(xsect)
  local index = xsect.transect
  F.getTransectParams(xsect, G.Transect[index])
end

-- xsect.c:651
F.xsect_setStreetXsectParams = function(xsect)
  local index = xsect.transect
  F.getTransectParams(xsect, G.Street[index].transect)
end

-- xsect.c:664
F.xsect_setCustomXsectParams = function(xsect)
  local G_Shape = G.Shape
  local index = G.Curve[xsect.transect].refersTo
  local yFull = xsect.yFull
  local i = 0
  local iMax = 0
  local wMax = 0.0
  local wTbl = G_Shape[index].widthTbl
  xsect.wMax = (G_Shape[index].wMax * yFull)
  xsect.aFull = ((G_Shape[index].aFull * yFull) * yFull)
  xsect.rFull = (G_Shape[index].rFull * yFull)
  xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
  xsect.sMax = (((G_Shape[index].sMax * yFull) * yFull) * (yFull ^ (2.0 / 3.0)))
  xsect.aBot = ((G_Shape[index].aMax * yFull) * yFull)
  iMax = 0
  wMax = wTbl[0]
  do
    i = 1
    while (i < 51) do
      do
        if (wTbl[i] < wMax) then
          break
        end
        wMax = wTbl[i]
        iMax = i
      end
      i = i + 1
    end
  end
  xsect.ywMax = ((yFull * (iMax * 1.0)) / (((51 - 1)) * 1.0))
end

-- xsect.c:700
F.xsect_getAmax = function(xsect)
  if (xsect.type_ == IRREGULAR) then
    do return xsect.aBot end
  elseif (xsect.type_ == CUSTOM) then
    do return xsect.aBot end
  else
    do return (G.Amax[xsect.type_] * xsect.aFull) end
  end
end

-- xsect.c:714
F.xsect_getSofA = function(xsect, a)
  local alpha = (a / xsect.aFull)
  local r = 0.0
  do
    local __sw1 = xsect.type_
    if __sw1 < HORSESHOE then
      if __sw1 < RECT_TRIANG then
        if __sw1 == CIRCULAR then goto case2
        elseif __sw1 == RECT_CLOSED then goto case10
        elseif __sw1 == RECT_OPEN then goto case11
        end
      else
        if __sw1 == RECT_TRIANG then goto case12
        elseif __sw1 == RECT_ROUND then goto case13
        elseif __sw1 == EGGSHAPED then goto case3
        end
      end
    else
      if __sw1 < SEMIELLIPTICAL then
        if __sw1 == HORSESHOE then goto case4
        elseif __sw1 == GOTHIC then goto case5
        elseif __sw1 == CATENARY then goto case6
        end
      else
        if __sw1 < SEMICIRCULAR then
          if __sw1 == SEMIELLIPTICAL then goto case7
          elseif __sw1 == BASKETHANDLE then goto case8
          end
        else
          if __sw1 == SEMICIRCULAR then goto case9
          elseif __sw1 == FORCE_MAIN then goto case2
          end
        end
      end
    end
    goto case14
    ::case2::
    do
      do return F.circ_getSofA(xsect, a) end
    end
    ::case3::
    do
      do return (xsect.sFull * F.lookup(alpha, G.S_Egg, G.N_S_Egg)) end
    end
    ::case4::
    do
      do return (xsect.sFull * F.lookup(alpha, G.S_Horseshoe, G.N_S_Horseshoe)) end
    end
    ::case5::
    do
      do return (xsect.sFull * F.lookup(alpha, G.S_Gothic, G.N_S_Gothic)) end
    end
    ::case6::
    do
      do return (xsect.sFull * F.lookup(alpha, G.S_Catenary, G.N_S_Catenary)) end
    end
    ::case7::
    do
      do return (xsect.sFull * F.lookup(alpha, G.S_SemiEllip, G.N_S_SemiEllip)) end
    end
    ::case8::
    do
      do return (xsect.sFull * F.lookup(alpha, G.S_BasketHandle, G.N_S_BasketHandle)) end
    end
    ::case9::
    do
      do return (xsect.sFull * F.lookup(alpha, G.S_SemiCirc, G.N_S_SemiCirc)) end
    end
    ::case10::
    do
      do return F.rect_closed_getSofA(xsect, a) end
    end
    ::case11::
    do
      do return F.rect_open_getSofA(xsect, a) end
    end
    ::case12::
    do
      do return F.rect_triang_getSofA(xsect, a) end
    end
    ::case13::
    do
      do return F.rect_round_getSofA(xsect, a) end
    end
    ::case14::
    do
      if (a == 0.0) then
        do return 0.0 end
      end
      r = F.xsect_getRofA(xsect, a)
      if (r < 1e-06) then
        do return 0.0 end
      end
      do return (a * (r ^ (2.0 / 3.0))) end
    end
    ::swend1::
  end
end

-- xsect.c:773
F.xsect_getYofA = function(xsect, a)
  local G_Street = G.Street
  local alpha = (a / xsect.aFull)
  do
    local __sw1 = xsect.type_
    if __sw1 < VERT_ELLIPSE then
      if __sw1 < PARABOLIC then
        if __sw1 < RECT_OPEN then
          if __sw1 == CIRCULAR then goto case2
          elseif __sw1 == FILLED_CIRCULAR then goto case3
          elseif __sw1 == RECT_CLOSED then goto case17
          end
        else
          if __sw1 == RECT_OPEN then goto case20
          elseif __sw1 == TRAPEZOIDAL then goto case22
          elseif __sw1 == TRIANGULAR then goto case23
          end
        end
      else
        if __sw1 < RECT_ROUND then
          if __sw1 == PARABOLIC then goto case24
          elseif __sw1 == POWERFUNC then goto case25
          elseif __sw1 == RECT_TRIANG then goto case18
          end
        else
          if __sw1 == RECT_ROUND then goto case19
          elseif __sw1 == MOD_BASKET then goto case21
          elseif __sw1 == HORIZ_ELLIPSE then goto case11
          end
        end
      end
    else
      if __sw1 < SEMIELLIPTICAL then
        if __sw1 < HORSESHOE then
          if __sw1 == VERT_ELLIPSE then goto case12
          elseif __sw1 == ARCH then goto case16
          elseif __sw1 == EGGSHAPED then goto case4
          end
        else
          if __sw1 == HORSESHOE then goto case5
          elseif __sw1 == GOTHIC then goto case6
          elseif __sw1 == CATENARY then goto case7
          end
        end
      else
        if __sw1 < IRREGULAR then
          if __sw1 == SEMIELLIPTICAL then goto case8
          elseif __sw1 == BASKETHANDLE then goto case9
          elseif __sw1 == SEMICIRCULAR then goto case10
          end
        else
          if __sw1 < FORCE_MAIN then
            if __sw1 == IRREGULAR then goto case13
            elseif __sw1 == CUSTOM then goto case14
            end
          else
            if __sw1 == FORCE_MAIN then goto case2
            elseif __sw1 == STREET_XSECT then goto case15
            end
          end
        end
      end
    end
    goto case26
    ::case2::
    do
      do return F.circ_getYofA(xsect, a) end
    end
    ::case3::
    do
      do return F.filled_circ_getYofA(xsect, a) end
    end
    ::case4::
    do
      do return (xsect.yFull * F.lookup(alpha, G.Y_Egg, G.N_Y_Egg)) end
    end
    ::case5::
    do
      do return (xsect.yFull * F.lookup(alpha, G.Y_Horseshoe, G.N_Y_Horseshoe)) end
    end
    ::case6::
    do
      do return (xsect.yFull * F.lookup(alpha, G.Y_Gothic, G.N_Y_Gothic)) end
    end
    ::case7::
    do
      do return (xsect.yFull * F.lookup(alpha, G.Y_Catenary, G.N_Y_Catenary)) end
    end
    ::case8::
    do
      do return (xsect.yFull * F.lookup(alpha, G.Y_SemiEllip, G.N_Y_SemiEllip)) end
    end
    ::case9::
    do
      do return (xsect.yFull * F.lookup(alpha, G.Y_BasketHandle, G.N_Y_BasketHandle)) end
    end
    ::case10::
    do
      do return (xsect.yFull * F.lookup(alpha, G.Y_SemiCirc, G.N_Y_SemiCirc)) end
    end
    ::case11::
    do
      do return (xsect.yFull * F.invLookup(alpha, G.A_HorizEllipse, G.N_A_HorizEllipse)) end
    end
    ::case12::
    do
      do return (xsect.yFull * F.invLookup(alpha, G.A_VertEllipse, G.N_A_VertEllipse)) end
    end
    ::case13::
    do
      do return (xsect.yFull * F.invLookup(alpha, G.Transect[xsect.transect].areaTbl, 51)) end
    end
    ::case14::
    do
      do return (xsect.yFull * F.invLookup(alpha, G.Shape[G.Curve[xsect.transect].refersTo].areaTbl, 51)) end
    end
    ::case15::
    do
      do return (xsect.yFull * F.invLookup(alpha, G_Street[xsect.transect].transect.areaTbl, G_Street[xsect.transect].transect.nTbl)) end
    end
    ::case16::
    do
      do return (xsect.yFull * F.invLookup(alpha, G.A_Arch, G.N_A_Arch)) end
    end
    ::case17::
    do
      do return (a / xsect.wMax) end
    end
    ::case18::
    do
      do return F.rect_triang_getYofA(xsect, a) end
    end
    ::case19::
    do
      do return F.rect_round_getYofA(xsect, a) end
    end
    ::case20::
    do
      do return (a / xsect.wMax) end
    end
    ::case21::
    do
      do return F.mod_basket_getYofA(xsect, a) end
    end
    ::case22::
    do
      do return F.trapez_getYofA(xsect, a) end
    end
    ::case23::
    do
      do return F.triang_getYofA(xsect, a) end
    end
    ::case24::
    do
      do return F.parab_getYofA(xsect, a) end
    end
    ::case25::
    do
      do return F.powerfunc_getYofA(xsect, a) end
    end
    ::case26::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- xsect.c:857
F.xsect_getAofY = function(xsect, y)
  local G_Street = G.Street
  local yNorm = (y / xsect.yFull)
  if (y <= 0.0) then
    do return 0.0 end
  end
  do
    local __sw1 = xsect.type_
    if __sw1 < VERT_ELLIPSE then
      if __sw1 < PARABOLIC then
        if __sw1 < RECT_OPEN then
          if __sw1 == CIRCULAR then goto case2
          elseif __sw1 == FILLED_CIRCULAR then goto case3
          elseif __sw1 == RECT_CLOSED then goto case17
          end
        else
          if __sw1 == RECT_OPEN then goto case20
          elseif __sw1 == TRAPEZOIDAL then goto case22
          elseif __sw1 == TRIANGULAR then goto case23
          end
        end
      else
        if __sw1 < RECT_ROUND then
          if __sw1 == PARABOLIC then goto case24
          elseif __sw1 == POWERFUNC then goto case25
          elseif __sw1 == RECT_TRIANG then goto case18
          end
        else
          if __sw1 == RECT_ROUND then goto case19
          elseif __sw1 == MOD_BASKET then goto case21
          elseif __sw1 == HORIZ_ELLIPSE then goto case11
          end
        end
      end
    else
      if __sw1 < SEMIELLIPTICAL then
        if __sw1 < HORSESHOE then
          if __sw1 == VERT_ELLIPSE then goto case12
          elseif __sw1 == ARCH then goto case13
          elseif __sw1 == EGGSHAPED then goto case4
          end
        else
          if __sw1 == HORSESHOE then goto case5
          elseif __sw1 == GOTHIC then goto case6
          elseif __sw1 == CATENARY then goto case7
          end
        end
      else
        if __sw1 < IRREGULAR then
          if __sw1 == SEMIELLIPTICAL then goto case8
          elseif __sw1 == BASKETHANDLE then goto case9
          elseif __sw1 == SEMICIRCULAR then goto case10
          end
        else
          if __sw1 < FORCE_MAIN then
            if __sw1 == IRREGULAR then goto case14
            elseif __sw1 == CUSTOM then goto case15
            end
          else
            if __sw1 == FORCE_MAIN then goto case2
            elseif __sw1 == STREET_XSECT then goto case16
            end
          end
        end
      end
    end
    goto case26
    ::case2::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.A_Circ, G.N_A_Circ)) end
    end
    ::case3::
    do
      do return F.filled_circ_getAofY(xsect, y) end
    end
    ::case4::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.A_Egg, G.N_A_Egg)) end
    end
    ::case5::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.A_Horseshoe, G.N_A_Horseshoe)) end
    end
    ::case6::
    do
      do return (xsect.aFull * F.invLookup(yNorm, G.Y_Gothic, G.N_Y_Gothic)) end
    end
    ::case7::
    do
      do return (xsect.aFull * F.invLookup(yNorm, G.Y_Catenary, G.N_Y_Catenary)) end
    end
    ::case8::
    do
      do return (xsect.aFull * F.invLookup(yNorm, G.Y_SemiEllip, G.N_Y_SemiEllip)) end
    end
    ::case9::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.A_Baskethandle, G.N_A_Baskethandle)) end
    end
    ::case10::
    do
      do return (xsect.aFull * F.invLookup(yNorm, G.Y_SemiCirc, G.N_Y_SemiCirc)) end
    end
    ::case11::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.A_HorizEllipse, G.N_A_HorizEllipse)) end
    end
    ::case12::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.A_VertEllipse, G.N_A_VertEllipse)) end
    end
    ::case13::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.A_Arch, G.N_A_Arch)) end
    end
    ::case14::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.Transect[xsect.transect].areaTbl, 51)) end
    end
    ::case15::
    do
      do return (xsect.aFull * F.lookup(yNorm, G.Shape[G.Curve[xsect.transect].refersTo].areaTbl, 51)) end
    end
    ::case16::
    do
      do return (xsect.aFull * F.lookup(yNorm, G_Street[xsect.transect].transect.areaTbl, G_Street[xsect.transect].transect.nTbl)) end
    end
    ::case17::
    do
      do return (y * xsect.wMax) end
    end
    ::case18::
    do
      do return F.rect_triang_getAofY(xsect, y) end
    end
    ::case19::
    do
      do return F.rect_round_getAofY(xsect, y) end
    end
    ::case20::
    do
      do return (y * xsect.wMax) end
    end
    ::case21::
    do
      do return F.mod_basket_getAofY(xsect, y) end
    end
    ::case22::
    do
      do return F.trapez_getAofY(xsect, y) end
    end
    ::case23::
    do
      do return F.triang_getAofY(xsect, y) end
    end
    ::case24::
    do
      do return F.parab_getAofY(xsect, y) end
    end
    ::case25::
    do
      do return F.powerfunc_getAofY(xsect, y) end
    end
    ::case26::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- xsect.c:943
F.xsect_getWofY = function(xsect, y)
  local G_W_Circ, G_Street = G.W_Circ, G.Street
  local yNorm = (y / xsect.yFull)
  do
    local __sw1 = xsect.type_
    if __sw1 < VERT_ELLIPSE then
      if __sw1 < PARABOLIC then
        if __sw1 < RECT_OPEN then
          if __sw1 == CIRCULAR then goto case2
          elseif __sw1 == FILLED_CIRCULAR then goto case3
          elseif __sw1 == RECT_CLOSED then goto case17
          end
        else
          if __sw1 == RECT_OPEN then goto case20
          elseif __sw1 == TRAPEZOIDAL then goto case22
          elseif __sw1 == TRIANGULAR then goto case23
          end
        end
      else
        if __sw1 < RECT_ROUND then
          if __sw1 == PARABOLIC then goto case24
          elseif __sw1 == POWERFUNC then goto case25
          elseif __sw1 == RECT_TRIANG then goto case18
          end
        else
          if __sw1 == RECT_ROUND then goto case19
          elseif __sw1 == MOD_BASKET then goto case21
          elseif __sw1 == HORIZ_ELLIPSE then goto case11
          end
        end
      end
    else
      if __sw1 < SEMIELLIPTICAL then
        if __sw1 < HORSESHOE then
          if __sw1 == VERT_ELLIPSE then goto case12
          elseif __sw1 == ARCH then goto case13
          elseif __sw1 == EGGSHAPED then goto case4
          end
        else
          if __sw1 == HORSESHOE then goto case5
          elseif __sw1 == GOTHIC then goto case6
          elseif __sw1 == CATENARY then goto case7
          end
        end
      else
        if __sw1 < IRREGULAR then
          if __sw1 == SEMIELLIPTICAL then goto case8
          elseif __sw1 == BASKETHANDLE then goto case9
          elseif __sw1 == SEMICIRCULAR then goto case10
          end
        else
          if __sw1 < FORCE_MAIN then
            if __sw1 == IRREGULAR then goto case14
            elseif __sw1 == CUSTOM then goto case15
            end
          else
            if __sw1 == FORCE_MAIN then goto case2
            elseif __sw1 == STREET_XSECT then goto case16
            end
          end
        end
      end
    end
    goto case26
    ::case2::
    do
      do return (xsect.wMax * F.lookup(yNorm, G_W_Circ, G.N_W_Circ)) end
    end
    ::case3::
    do
      yNorm = (((y + xsect.yBot)) / ((xsect.yFull + xsect.yBot)))
      do return (xsect.wMax * F.lookup(yNorm, G_W_Circ, G.N_W_Circ)) end
    end
    ::case4::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_Egg, G.N_W_Egg)) end
    end
    ::case5::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_Horseshoe, G.N_W_Horseshoe)) end
    end
    ::case6::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_Gothic, G.N_W_Gothic)) end
    end
    ::case7::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_Catenary, G.N_W_Catenary)) end
    end
    ::case8::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_SemiEllip, G.N_W_SemiEllip)) end
    end
    ::case9::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_BasketHandle, G.N_W_BasketHandle)) end
    end
    ::case10::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_SemiCirc, G.N_W_SemiCirc)) end
    end
    ::case11::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_HorizEllipse, G.N_W_HorizEllipse)) end
    end
    ::case12::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_VertEllipse, G.N_W_VertEllipse)) end
    end
    ::case13::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.W_Arch, G.N_W_Arch)) end
    end
    ::case14::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.Transect[xsect.transect].widthTbl, 51)) end
    end
    ::case15::
    do
      do return (xsect.wMax * F.lookup(yNorm, G.Shape[G.Curve[xsect.transect].refersTo].widthTbl, 51)) end
    end
    ::case16::
    do
      do return (xsect.wMax * F.lookup(yNorm, G_Street[xsect.transect].transect.widthTbl, G_Street[xsect.transect].transect.nTbl)) end
    end
    ::case17::
    do
      if (yNorm == 1.0) then
        do return 0.0 end
      end
      do return xsect.wMax end
    end
    ::case18::
    do
      do return F.rect_triang_getWofY(xsect, y) end
    end
    ::case19::
    do
      do return F.rect_round_getWofY(xsect, y) end
    end
    ::case20::
    do
      do return xsect.wMax end
    end
    ::case21::
    do
      do return F.mod_basket_getWofY(xsect, y) end
    end
    ::case22::
    do
      do return F.trapez_getWofY(xsect, y) end
    end
    ::case23::
    do
      do return F.triang_getWofY(xsect, y) end
    end
    ::case24::
    do
      do return F.parab_getWofY(xsect, y) end
    end
    ::case25::
    do
      do return F.powerfunc_getWofY(xsect, y) end
    end
    ::case26::
    do
      do return 0.0 end
    end
    ::swend1::
  end
end

-- xsect.c:1031
F.xsect_getRofY = function(xsect, y)
  local G_R_Circ, G_Street = G.R_Circ, G.Street
  local yNorm = (y / xsect.yFull)
  do
    local __sw1 = xsect.type_
    if __sw1 < VERT_ELLIPSE then
      if __sw1 < PARABOLIC then
        if __sw1 < TRAPEZOIDAL then
          if __sw1 == CIRCULAR then goto case2
          elseif __sw1 == FILLED_CIRCULAR then goto case3
          end
        else
          if __sw1 == TRAPEZOIDAL then goto case15
          elseif __sw1 == TRIANGULAR then goto case16
          end
        end
      else
        if __sw1 < RECT_TRIANG then
          if __sw1 == PARABOLIC then goto case17
          elseif __sw1 == POWERFUNC then goto case18
          end
        else
          if __sw1 == RECT_TRIANG then goto case13
          elseif __sw1 == RECT_ROUND then goto case14
          elseif __sw1 == HORIZ_ELLIPSE then goto case7
          end
        end
      end
    else
      if __sw1 < BASKETHANDLE then
        if __sw1 < EGGSHAPED then
          if __sw1 == VERT_ELLIPSE then goto case8
          elseif __sw1 == ARCH then goto case9
          end
        else
          if __sw1 == EGGSHAPED then goto case4
          elseif __sw1 == HORSESHOE then goto case5
          end
        end
      else
        if __sw1 < CUSTOM then
          if __sw1 == BASKETHANDLE then goto case6
          elseif __sw1 == IRREGULAR then goto case10
          end
        else
          if __sw1 == CUSTOM then goto case11
          elseif __sw1 == FORCE_MAIN then goto case2
          elseif __sw1 == STREET_XSECT then goto case12
          end
        end
      end
    end
    goto case19
    ::case2::
    do
      do return (xsect.rFull * F.lookup(yNorm, G_R_Circ, G.N_R_Circ)) end
    end
    ::case3::
    do
      if (xsect.yBot == 0.0) then
        do return (xsect.rFull * F.lookup(yNorm, G_R_Circ, G.N_R_Circ)) end
      end
      do return F.filled_circ_getRofY(xsect, y) end
    end
    ::case4::
    do
      do return (xsect.rFull * F.lookup(yNorm, G.R_Egg, G.N_R_Egg)) end
    end
    ::case5::
    do
      do return (xsect.rFull * F.lookup(yNorm, G.R_Horseshoe, G.N_R_Horseshoe)) end
    end
    ::case6::
    do
      do return (xsect.rFull * F.lookup(yNorm, G.R_Baskethandle, G.N_R_Baskethandle)) end
    end
    ::case7::
    do
      do return (xsect.rFull * F.lookup(yNorm, G.R_HorizEllipse, G.N_R_HorizEllipse)) end
    end
    ::case8::
    do
      do return (xsect.rFull * F.lookup(yNorm, G.R_VertEllipse, G.N_R_VertEllipse)) end
    end
    ::case9::
    do
      do return (xsect.rFull * F.lookup(yNorm, G.R_Arch, G.N_R_Arch)) end
    end
    ::case10::
    do
      do return (xsect.rFull * F.lookup(yNorm, G.Transect[xsect.transect].hradTbl, 51)) end
    end
    ::case11::
    do
      do return (xsect.rFull * F.lookup(yNorm, G.Shape[G.Curve[xsect.transect].refersTo].hradTbl, 51)) end
    end
    ::case12::
    do
      do return (xsect.rFull * F.lookup(yNorm, G_Street[xsect.transect].transect.hradTbl, G_Street[xsect.transect].transect.nTbl)) end
    end
    ::case13::
    do
      do return F.rect_triang_getRofY(xsect, y) end
    end
    ::case14::
    do
      do return F.rect_round_getRofY(xsect, y) end
    end
    ::case15::
    do
      do return F.trapez_getRofY(xsect, y) end
    end
    ::case16::
    do
      do return F.triang_getRofY(xsect, y) end
    end
    ::case17::
    do
      do return F.parab_getRofY(xsect, y) end
    end
    ::case18::
    do
      do return F.powerfunc_getRofY(xsect, y) end
    end
    ::case19::
    do
      do return F.xsect_getRofA(xsect, F.xsect_getAofY(xsect, y)) end
    end
    ::swend1::
  end
end

-- xsect.c:1100
F.xsect_getRofA = function(xsect, a)
  local cathy = 0.0
  if (a <= 0.0) then
    do return 0.0 end
  end
  do
    local __sw1 = xsect.type_
    if __sw1 < RECT_ROUND then
      if __sw1 < TRIANGULAR then
        if __sw1 < RECT_OPEN then
          if __sw1 == FILLED_CIRCULAR then goto case2
          elseif __sw1 == RECT_CLOSED then goto case3
          end
        else
          if __sw1 == RECT_OPEN then goto case4
          elseif __sw1 == TRAPEZOIDAL then goto case8
          end
        end
      else
        if __sw1 < POWERFUNC then
          if __sw1 == TRIANGULAR then goto case9
          elseif __sw1 == PARABOLIC then goto case10
          end
        else
          if __sw1 == POWERFUNC then goto case11
          elseif __sw1 == RECT_TRIANG then goto case5
          end
        end
      end
    else
      if __sw1 < ARCH then
        if __sw1 < HORIZ_ELLIPSE then
          if __sw1 == RECT_ROUND then goto case6
          elseif __sw1 == MOD_BASKET then goto case7
          end
        else
          if __sw1 == HORIZ_ELLIPSE then goto case2
          elseif __sw1 == VERT_ELLIPSE then goto case2
          end
        end
      else
        if __sw1 < CUSTOM then
          if __sw1 == ARCH then goto case2
          elseif __sw1 == IRREGULAR then goto case2
          end
        else
          if __sw1 == CUSTOM then goto case2
          elseif __sw1 == STREET_XSECT then goto case2
          end
        end
      end
    end
    goto case12
    ::case2::
    do
      do return F.xsect_getRofY(xsect, F.xsect_getYofA(xsect, a)) end
    end
    ::case3::
    do
      do return F.rect_closed_getRofA(xsect, a) end
    end
    ::case4::
    do
      do return (a / ((xsect.wMax + ((((2.0 - xsect.sBot)) * a) / xsect.wMax)))) end
    end
    ::case5::
    do
      do return F.rect_triang_getRofA(xsect, a) end
    end
    ::case6::
    do
      do return F.rect_round_getRofA(xsect, a) end
    end
    ::case7::
    do
      do return F.mod_basket_getRofA(xsect, a) end
    end
    ::case8::
    do
      do return F.trapez_getRofA(xsect, a) end
    end
    ::case9::
    do
      do return F.triang_getRofA(xsect, a) end
    end
    ::case10::
    do
      do return F.parab_getRofA(xsect, a) end
    end
    ::case11::
    do
      do return F.powerfunc_getRofA(xsect, a) end
    end
    ::case12::
    do
      cathy = F.xsect_getSofA(xsect, a)
      if ((cathy < 1e-06) or (a < 1e-06)) then
        do return 0.0 end
      end
      do return ((cathy / a) ^ (3.0 / 2.0)) end
    end
    ::swend1::
  end
end

-- xsect.c:1149
F.xsect_getAofS = function(xsect, s)
  local psi = (s / xsect.sFull)
  if (s <= 0.0) then
    do return 0.0 end
  end
  if (s > xsect.sMax) then
    s = xsect.sMax
  end
  do
    local __sw1 = xsect.type_
    if __sw1 < CATENARY then
      if __sw1 < EGGSHAPED then
        if __sw1 == DUMMY then goto case2
        elseif __sw1 == CIRCULAR then goto case3
        end
      else
        if __sw1 == EGGSHAPED then goto case4
        elseif __sw1 == HORSESHOE then goto case5
        elseif __sw1 == GOTHIC then goto case6
        end
      end
    else
      if __sw1 < BASKETHANDLE then
        if __sw1 == CATENARY then goto case7
        elseif __sw1 == SEMIELLIPTICAL then goto case8
        end
      else
        if __sw1 == BASKETHANDLE then goto case9
        elseif __sw1 == SEMICIRCULAR then goto case10
        elseif __sw1 == FORCE_MAIN then goto case3
        end
      end
    end
    goto case11
    ::case2::
    do
      do return 0.0 end
    end
    ::case3::
    do
      do return F.circ_getAofS(xsect, s) end
    end
    ::case4::
    do
      do return (xsect.aFull * F.invLookup(psi, G.S_Egg, G.N_S_Egg)) end
    end
    ::case5::
    do
      do return (xsect.aFull * F.invLookup(psi, G.S_Horseshoe, G.N_S_Horseshoe)) end
    end
    ::case6::
    do
      do return (xsect.aFull * F.invLookup(psi, G.S_Gothic, G.N_S_Gothic)) end
    end
    ::case7::
    do
      do return (xsect.aFull * F.invLookup(psi, G.S_Catenary, G.N_S_Catenary)) end
    end
    ::case8::
    do
      do return (xsect.aFull * F.invLookup(psi, G.S_SemiEllip, G.N_S_SemiEllip)) end
    end
    ::case9::
    do
      do return (xsect.aFull * F.invLookup(psi, G.S_BasketHandle, G.N_S_BasketHandle)) end
    end
    ::case10::
    do
      do return (xsect.aFull * F.invLookup(psi, G.S_SemiCirc, G.N_S_SemiCirc)) end
    end
    ::case11::
    do
      do return F.generic_getAofS(xsect, s) end
    end
    ::swend1::
  end
end

-- xsect.c:1194
F.xsect_getdSdA = function(xsect, a)
  do
    local __sw1 = xsect.type_
    if __sw1 < EGGSHAPED then
      if __sw1 < TRIANGULAR then
        if __sw1 < RECT_OPEN then
          if __sw1 == CIRCULAR then goto case2
          elseif __sw1 == RECT_CLOSED then goto case10
          end
        else
          if __sw1 == RECT_OPEN then goto case11
          elseif __sw1 == TRAPEZOIDAL then goto case15
          end
        end
      else
        if __sw1 < RECT_ROUND then
          if __sw1 == TRIANGULAR then goto case16
          elseif __sw1 == RECT_TRIANG then goto case12
          end
        else
          if __sw1 == RECT_ROUND then goto case13
          elseif __sw1 == MOD_BASKET then goto case14
          end
        end
      end
    else
      if __sw1 < SEMIELLIPTICAL then
        if __sw1 < GOTHIC then
          if __sw1 == EGGSHAPED then goto case3
          elseif __sw1 == HORSESHOE then goto case4
          end
        else
          if __sw1 == GOTHIC then goto case5
          elseif __sw1 == CATENARY then goto case6
          end
        end
      else
        if __sw1 < SEMICIRCULAR then
          if __sw1 == SEMIELLIPTICAL then goto case7
          elseif __sw1 == BASKETHANDLE then goto case8
          end
        else
          if __sw1 == SEMICIRCULAR then goto case9
          elseif __sw1 == FORCE_MAIN then goto case2
          end
        end
      end
    end
    goto case17
    ::case2::
    do
      do return F.circ_getdSdA(xsect, a) end
    end
    ::case3::
    do
      do return F.tabular_getdSdA(xsect, a, G.S_Egg, G.N_S_Egg) end
    end
    ::case4::
    do
      do return F.tabular_getdSdA(xsect, a, G.S_Horseshoe, G.N_S_Horseshoe) end
    end
    ::case5::
    do
      do return F.tabular_getdSdA(xsect, a, G.S_Gothic, G.N_S_Gothic) end
    end
    ::case6::
    do
      do return F.tabular_getdSdA(xsect, a, G.S_Catenary, G.N_S_Catenary) end
    end
    ::case7::
    do
      do return F.tabular_getdSdA(xsect, a, G.S_SemiEllip, G.N_S_SemiEllip) end
    end
    ::case8::
    do
      do return F.tabular_getdSdA(xsect, a, G.S_BasketHandle, G.N_S_BasketHandle) end
    end
    ::case9::
    do
      do return F.tabular_getdSdA(xsect, a, G.S_SemiCirc, G.N_S_SemiCirc) end
    end
    ::case10::
    do
      do return F.rect_closed_getdSdA(xsect, a) end
    end
    ::case11::
    do
      do return F.rect_open_getdSdA(xsect, a) end
    end
    ::case12::
    do
      do return F.rect_triang_getdSdA(xsect, a) end
    end
    ::case13::
    do
      do return F.rect_round_getdSdA(xsect, a) end
    end
    ::case14::
    do
      do return F.mod_basket_getdSdA(xsect, a) end
    end
    ::case15::
    do
      do return F.trapez_getdSdA(xsect, a) end
    end
    ::case16::
    do
      do return F.triang_getdSdA(xsect, a) end
    end
    ::case17::
    do
      do return F.generic_getdSdA(xsect, a) end
    end
    ::swend1::
  end
end

-- xsect.c:1257
F.xsect_getYcrit = function(xsect, q)
  local q2g = ((((q) * (q))) / 32.2)
  local y = 0.0
  local r = 0.0
  if (q2g == 0.0) then
    do return 0.0 end
  end
  do
    local __sw1 = xsect.type_
    if __sw1 < TRIANGULAR then
      if __sw1 == DUMMY then goto case2
      elseif __sw1 == RECT_CLOSED then goto case3
      elseif __sw1 == RECT_OPEN then goto case3
      end
    else
      if __sw1 == TRIANGULAR then goto case4
      elseif __sw1 == PARABOLIC then goto case5
      elseif __sw1 == POWERFUNC then goto case6
      end
    end
    goto case7
    ::case2::
    do
      do return 0.0 end
    end
    ::case3::
    do
      y = ((q2g / (((xsect.wMax) * (xsect.wMax)))) ^ (1.0 / 3.0))
      goto swend1
    end
    ::case4::
    do
      y = (((2.0 * q2g) / (((xsect.sBot) * (xsect.sBot)))) ^ (1.0 / 5.0))
      goto swend1
    end
    ::case5::
    do
      y = ((((27.0 / 32.0) * q2g) / (((xsect.rBot) * (xsect.rBot)))) ^ (1.0 / 4.0))
      goto swend1
    end
    ::case6::
    do
      y = (1.0 / (((2.0 * xsect.sBot) + 3.0)))
      y = R.pow(((q2g * ((xsect.sBot + 1.0))) / (((xsect.rBot) * (xsect.rBot)))), y)
      goto swend1
    end
    ::case7::
    do
      y = (1.01 * ((q2g / xsect.yFull) ^ (1.0 / 4.0)))
      if (y >= xsect.yFull) then
        y = (0.97 * xsect.yFull)
      end
      r = (xsect.aFull / (((3.141592654 / 4.0) * (((xsect.yFull) * (xsect.yFull))))))
      if ((r >= 0.5) and (r <= 2.0)) then
        y = F.getYcritEnum(xsect, q, y)
      else
        y = F.getYcritRidder(xsect, q, y)
      end
    end
    ::swend1::
  end
  do return (((((y) <= (xsect.yFull))) and (y) or (xsect.yFull))) end
end

-- xsect.c:1323
F.getTransectParams = function(xsect, transect)
  local i = 0
  local iMax = 0
  local wMax = 0.0
  local wTbl = transect.widthTbl
  xsect.yFull = transect.yFull
  xsect.wMax = transect.wMax
  xsect.aFull = transect.aFull
  xsect.rFull = transect.rFull
  xsect.sFull = (xsect.aFull * (xsect.rFull ^ (2.0 / 3.0)))
  xsect.sMax = transect.sMax
  xsect.aBot = transect.aMax
  iMax = 0
  wMax = wTbl[0]
  do
    i = 1
    while (i < transect.nTbl) do
      do
        if (wTbl[i] < wMax) then
          break
        end
        wMax = wTbl[i]
        iMax = i
      end
      i = i + 1
    end
  end
  xsect.ywMax = ((xsect.yFull * (iMax * 1.0)) / ((((transect.nTbl) * 1.0) - 1.0)))
end

-- xsect.c:1359
F.generic_getAofS = function(xsect, s)
  local a = {0.0}
  local a1 = 0.0
  local a2 = 0.0
  local tol = 0.0
  local xsectStar = T.TXsectStar()
  if (s <= 0.0) then
    do return 0.0 end
  end
  if ((((s <= xsect.sMax) and (s >= xsect.sFull))) and (xsect.sMax ~= xsect.sFull)) then
    a1 = xsect.aFull
    a2 = F.xsect_getAmax(xsect)
  else
    a1 = 0.0
    a2 = F.xsect_getAmax(xsect)
  end
  xsectStar.xsect = xsect
  xsectStar.s = s
  a[1] = (0.5 * ((a1 + a2)))
  tol = (0.0001 * xsect.aFull)
  F.findroot_Newton(a1, a2, a, 1, tol, F.evalSofA, xsectStar)
  do return a[1] end
end

-- xsect.c:1404
F.evalSofA = function(a, f, f__k, df, df__k, p)
  local xsectStar = nil
  local s = 0.0
  xsectStar = p
  s = F.xsect_getSofA(xsectStar.xsect, a)
  f[f__k] = (s - xsectStar.s)
  df[df__k] = F.xsect_getdSdA(xsectStar.xsect, a)
end

-- xsect.c:1424
F.tabular_getdSdA = function(xsect, a, table_, nItems)
  local i = 0
  local alpha = (a / xsect.aFull)
  local delta = (1.0 / (((nItems * 1.0) - 1.0)))
  local dSdA = 0.0
  i = R.D2I(((alpha / delta)))
  if (i >= (nItems - 1)) then
    i = (nItems - 2)
  end
  dSdA = (((table_[(i + 1)] - table_[i])) / delta)
  do return ((dSdA * xsect.sFull) / xsect.aFull) end
end

-- xsect.c:1453
F.generic_getdSdA = function(xsect, a)
  local a1 = 0.0
  local a2 = 0.0
  local alpha = (a / xsect.aFull)
  local alpha1 = (alpha - 0.001)
  local alpha2 = (alpha + 0.001)
  if (alpha1 < 0.0) then
    alpha1 = 0.0
  end
  a1 = (alpha1 * xsect.aFull)
  a2 = (alpha2 * xsect.aFull)
  do return (((F.xsect_getSofA(xsect, a2) - F.xsect_getSofA(xsect, a1))) / ((a2 - a1))) end
end

-- xsect.c:1474
F.lookup = function(x, table_, nItems)
  local delta = 0.0
  local x0 = 0.0
  local x1 = 0.0
  local y = 0.0
  local y2 = 0.0
  local i = 0
  delta = (1.0 / (((nItems * 1.0) - 1.0)))
  i = R.D2I(((x / delta)))
  if (i >= (nItems - 1)) then
    do return table_[(nItems - 1)] end
  end
  x0 = ((i * 1.0) * delta)
  x1 = ((((i * 1.0) + 1.0)) * delta)
  y = (table_[i] + ((((x - x0)) * ((table_[(i + 1)] - table_[i]))) / delta))
  if (i < 2) then
    y2 = (y + (((((x - x0)) * ((x - x1))) / ((delta * delta))) * ((((table_[i] / 2.0) - table_[(i + 1)]) + (table_[(i + 2)] / 2.0)))))
    if (y2 > 0.0) then
      y = y2
    end
  end
  if (y < 0.0) then
    y = 0.0
  end
  do return y end
end

-- xsect.c:1511
F.invLookup = function(y, table_, nItems)
  local dx = 0.0
  local x = 0.0
  local x0 = 0.0
  local dy = 0.0
  local n = 0
  local i = 0
  dx = (1.0 / (((nItems * 1.0) - 1.0)))
  n = nItems
  if (table_[(n - 3)] > table_[(n - 1)]) then
    n = (n - 2)
  end
  if ((n < nItems) and (y > table_[(nItems - 1)])) then
    if (y >= table_[(nItems - 3)]) then
      do return ((((n * 1.0) - 1.0)) * dx) end
    end
    if (y <= table_[(nItems - 2)]) then
      i = (nItems - 2)
    else
      i = (nItems - 3)
    end
  else
    i = F.locate(y, table_, (n - 1))
  end
  if (i >= (n - 1)) then
    do return ((((n * 1.0) - 1.0)) * dx) end
  end
  x0 = ((i * 1.0) * dx)
  dy = (table_[(i + 1)] - table_[i])
  if (dy == 0.0) then
    x = x0
  else
    x = (x0 + ((((y - table_[i])) * dx) / dy))
  end
  if (x < 0.0) then
    x = 0.0
  end
  if (x > 1.0) then
    x = 1.0
  end
  do return x end
end

-- xsect.c:1571
F.locate = function(y, table_, jLast)
  local j = 0
  local j1 = 0
  local j2 = jLast
  if (y <= table_[0]) then
    do return 0 end
  end
  if (y >= table_[jLast]) then
    do return jLast end
  end
  while ((j2 - j1) > 1) do
    do
      j = (((j1 + j2)) // (1 << 1))
      if (y >= table_[j]) then
        j1 = j
      else
        j2 = j
      end
    end
  end
  do return j1 end
end

-- xsect.c:1612
F.getQcritical = function(yc, p)
  local a = 0.0
  local w = 0.0
  local qc = 0.0
  local xsectStar = nil
  xsectStar = p
  a = F.xsect_getAofY(xsectStar.xsect, yc)
  w = F.xsect_getWofY(xsectStar.xsect, yc)
  qc = (-xsectStar.qc)
  if (w > 0.0) then
    qc = ((a * m_sqrt(((32.2 * a) / w))) - xsectStar.qc)
  end
  do return qc end
end

-- xsect.c:1634
F.getYcritEnum = function(xsect, q, y0)
  local q0 = 0.0
  local dy = 0.0
  local qc = 0.0
  local yc = 0.0
  local i1 = 0
  local i = 0
  local xsectStar = T.TXsectStar()
  dy = (xsect.yFull / 25.0)
  i1 = R.D2I(((y0 / dy)))
  xsectStar.xsect = xsect
  xsectStar.qc = 0.0
  q0 = F.getQcritical(((i1 * 1.0) * dy), xsectStar)
  if (q0 < q) then
    yc = xsect.yFull
    do
      i = (i1 + 1)
      while (i <= 25) do
        do
          qc = F.getQcritical(((i * 1.0) * dy), xsectStar)
          if (qc >= q) then
            yc = ((((((q - q0)) / ((qc - q0))) + (((i * 1.0) - 1.0)))) * dy)
            break
          end
          q0 = qc
        end
        i = i + 1
      end
    end
  else
    yc = 0.0
    do
      i = (i1 - 1)
      while (i >= 0) do
        do
          qc = F.getQcritical(((i * 1.0) * dy), xsectStar)
          if (qc < q) then
            yc = ((((((q - qc)) / ((q0 - qc))) + (i * 1.0))) * dy)
            break
          end
          q0 = qc
        end
        i = i - 1
      end
    end
  end
  do return yc end
end

-- xsect.c:1700
F.getYcritRidder = function(xsect, q, y0)
  local y1 = 0.0
  local y2 = (0.99 * xsect.yFull)
  local yc = 0.0
  local q0 = 0.0
  local q1 = 0.0
  local q2 = 0.0
  local xsectStar = T.TXsectStar()
  xsectStar.xsect = xsect
  xsectStar.qc = 0.0
  q2 = F.getQcritical(y2, xsectStar)
  if (q2 < q) then
    do return xsect.yFull end
  end
  q0 = F.getQcritical(y0, xsectStar)
  q1 = F.getQcritical((0.5 * xsect.yFull), xsectStar)
  if (q0 > q) then
    y2 = y0
    if (q1 < q) then
      y1 = (0.5 * xsect.yFull)
    end
  else
    y1 = y0
    if (q1 > q) then
      y2 = (0.5 * xsect.yFull)
    end
  end
  xsectStar.qc = q
  yc = F.findroot_Ridder(y1, y2, 0.001, F.getQcritical, xsectStar)
  do return yc end
end

-- xsect.c:1755
F.rect_closed_getSofA = function(xsect, a)
  local alfMax = 0.97
  if ((a / xsect.aFull) > alfMax) then
    do return (xsect.sMax + ((((xsect.sFull - xsect.sMax)) * (((a / xsect.aFull) - alfMax))) / ((1.0 - alfMax)))) end
  end
  do return (a * ((F.xsect_getRofA(xsect, a)) ^ (2.0 / 3.0))) end
end

-- xsect.c:1770
F.rect_closed_getdSdA = function(xsect, a)
  local alpha = 0.0
  local alfMax = 0.0
  local r = 0.0
  alfMax = 0.97
  alpha = (a / xsect.aFull)
  if (alpha > alfMax) then
    do return (((xsect.sFull - xsect.sMax)) / ((((1.0 - alfMax)) * xsect.aFull))) end
  end
  if (alpha <= 1e-30) then
    do return F.generic_getdSdA(xsect, a) end
  end
  r = F.xsect_getRofA(xsect, a)
  do return ((((5.0 / 3.0) - ((((2.0 / 3.0)) * ((2.0 / xsect.wMax))) * r))) * (r ^ (2.0 / 3.0))) end
end

-- xsect.c:1793
F.rect_closed_getRofA = function(xsect, a)
  local p = 0.0
  if (a <= 0.0) then
    do return 0.0 end
  end
  p = (xsect.wMax + ((2.0 * a) / xsect.wMax))
  if ((a / xsect.aFull) > 0.97) then
    p = (p + (((((a / xsect.aFull) - 0.97)) / ((1.0 - 0.97))) * xsect.wMax))
  end
  do return (a / p) end
end

-- xsect.c:1810
F.rect_open_getSofA = function(xsect, a)
  local y = (a / xsect.wMax)
  local r = (a / (((((2.0 - xsect.sBot)) * y) + xsect.wMax)))
  do return (a * (r ^ (2.0 / 3.0))) end
end

-- xsect.c:1818
F.rect_open_getdSdA = function(xsect, a)
  local r = 0.0
  local dPdA = 0.0
  if ((a / xsect.aFull) <= 1e-30) then
    do return F.generic_getdSdA(xsect, a) end
  end
  r = F.xsect_getRofA(xsect, a)
  dPdA = (((2.0 - xsect.sBot)) / xsect.wMax)
  do return ((((5.0 / 3.0) - ((((2.0 / 3.0)) * dPdA) * r))) * (r ^ (2.0 / 3.0))) end
end

-- xsect.c:1837
F.rect_triang_getYofA = function(xsect, a)
  if (a <= xsect.aBot) then
    do return m_sqrt((a / xsect.sBot)) end
  else
    do return (xsect.yBot + (((a - xsect.aBot)) / xsect.wMax)) end
  end
end

-- xsect.c:1846
F.rect_triang_getRofA = function(xsect, a)
  local y = 0.0
  local p = 0.0
  local alf = 0.0
  if (a <= 0.0) then
    do return 0.0 end
  end
  y = F.rect_triang_getYofA(xsect, a)
  if (y <= xsect.yBot) then
    do return (a / (((2.0 * y) * xsect.rBot))) end
  end
  p = (((2.0 * xsect.yBot) * xsect.rBot) + (2.0 * ((y - xsect.yBot))))
  alf = (((a / xsect.aFull)) - 0.98)
  if (alf > 0.0) then
    p = (p + ((alf / ((1.0 - 0.98))) * xsect.wMax))
  end
  do return (a / p) end
end

-- xsect.c:1866
F.rect_triang_getSofA = function(xsect, a)
  local alfMax = 0.98
  if ((a / xsect.aFull) > alfMax) then
    do return (xsect.sMax + ((((xsect.sFull - xsect.sMax)) * (((a / xsect.aFull) - alfMax))) / ((1.0 - alfMax)))) end
  else
    do return (a * ((F.rect_triang_getRofA(xsect, a)) ^ (2.0 / 3.0))) end
  end
end

-- xsect.c:1879
F.rect_triang_getdSdA = function(xsect, a)
  local alpha = 0.0
  local alfMax = 0.0
  local dPdA = 0.0
  local r = 0.0
  alfMax = 0.98
  alpha = (a / xsect.aFull)
  if (alpha > alfMax) then
    do return (((xsect.sFull - xsect.sMax)) / ((((1.0 - alfMax)) * xsect.aFull))) end
  end
  if (alpha <= 1e-30) then
    do return F.generic_getdSdA(xsect, a) end
  end
  if (a > xsect.aBot) then
    dPdA = (2.0 / xsect.wMax)
  else
    dPdA = (xsect.rBot / m_sqrt((a * xsect.sBot)))
  end
  r = F.rect_triang_getRofA(xsect, a)
  do return ((((5.0 / 3.0) - ((((2.0 / 3.0)) * dPdA) * r))) * (r ^ (2.0 / 3.0))) end
end

-- xsect.c:1902
F.rect_triang_getAofY = function(xsect, y)
  if (y <= xsect.yBot) then
    do return ((y * y) * xsect.sBot) end
  else
    do return (xsect.aBot + (((y - xsect.yBot)) * xsect.wMax)) end
  end
end

-- xsect.c:1908
F.rect_triang_getRofY = function(xsect, y)
  local p = 0.0
  local a = 0.0
  local alf = 0.0
  if (y <= xsect.yBot) then
    do return ((y * xsect.sBot) / ((2.0 * xsect.rBot))) end
  end
  a = (xsect.aBot + (((y - xsect.yBot)) * xsect.wMax))
  p = (((2.0 * xsect.yBot) * xsect.rBot) + (2.0 * ((y - xsect.yBot))))
  alf = (((a / xsect.aFull)) - 0.98)
  if (alf > 0.0) then
    p = (p + ((alf / ((1.0 - 0.98))) * xsect.wMax))
  end
  do return (a / p) end
end

-- xsect.c:1927
F.rect_triang_getWofY = function(xsect, y)
  if (y <= xsect.yBot) then
    do return ((2.0 * xsect.sBot) * y) end
  else
    do return xsect.wMax end
  end
end

-- xsect.c:1938
F.rect_round_getYofA = function(xsect, a)
  local alpha = 0.0
  if (a > xsect.aBot) then
    do return (xsect.yBot + (((a - xsect.aBot)) / xsect.wMax)) end
  end
  alpha = (a / (((3.141592654 * xsect.rBot) * xsect.rBot)))
  if (alpha < 0.04) then
    do return (((2.0 * xsect.rBot)) * F.getYcircular(alpha)) end
  end
  do return (((2.0 * xsect.rBot)) * F.lookup(alpha, G.Y_Circ, G.N_Y_Circ)) end
end

-- xsect.c:1952
F.rect_round_getRofA = function(xsect, a)
  local y1 = 0.0
  local theta1 = 0.0
  local p = 0.0
  local arg = 0.0
  if (a <= 0.0) then
    do return 0.0 end
  end
  if (a > xsect.aBot) then
    y1 = (((a - xsect.aBot)) / xsect.wMax)
    theta1 = (2.0 * m_asin(((xsect.wMax / 2.0) / xsect.rBot)))
    p = ((xsect.rBot * theta1) + (2.0 * y1))
    arg = (((a / xsect.aFull)) - 0.98)
    if (arg > 0.0) then
      p = (p + ((arg / ((1.0 - 0.98))) * xsect.wMax))
    end
    do return (a / p) end
  end
  y1 = F.rect_round_getYofA(xsect, a)
  theta1 = (2.0 * m_acos((1.0 - (y1 / xsect.rBot))))
  p = (xsect.rBot * theta1)
  do return (a / p) end
end

-- xsect.c:1978
F.rect_round_getSofA = function(xsect, a)
  local alpha = 0.0
  local aFull = 0.0
  local sFull = 0.0
  local alfMax = 0.98
  if ((a / xsect.aFull) > alfMax) then
    do return (xsect.sMax + ((((xsect.sFull - xsect.sMax)) * (((a / xsect.aFull) - alfMax))) / ((1.0 - alfMax)))) end
  elseif (a > xsect.aBot) then
    do return (a * ((F.xsect_getRofA(xsect, a)) ^ (2.0 / 3.0))) end
  else
    aFull = ((3.141592654 * xsect.rBot) * xsect.rBot)
    alpha = (a / aFull)
    sFull = xsect.sBot
    if (alpha < 0.04) then
      do return (sFull * F.getScircular(alpha)) end
    else
      do return (sFull * F.lookup(alpha, G.S_Circ, G.N_S_Circ)) end
    end
  end
end

-- xsect.c:2013
F.rect_round_getdSdA = function(xsect, a)
  local alfMax = 0.0
  local r = 0.0
  local dPdA = 0.0
  alfMax = 0.98
  if ((a / xsect.aFull) > alfMax) then
    do return (((xsect.sFull - xsect.sMax)) / ((((1.0 - alfMax)) * xsect.aFull))) end
  elseif (a > xsect.aBot) then
    r = F.rect_round_getRofA(xsect, a)
    dPdA = (2.0 / xsect.wMax)
    do return ((((5.0 / 3.0) - ((((2.0 / 3.0)) * dPdA) * r))) * (r ^ (2.0 / 3.0))) end
  else
    do return F.generic_getdSdA(xsect, a) end
  end
end

-- xsect.c:2038
F.rect_round_getAofY = function(xsect, y)
  local theta1 = 0.0
  if (y > xsect.yBot) then
    do return (xsect.aBot + (((y - xsect.yBot)) * xsect.wMax)) end
  end
  theta1 = (2.0 * m_acos((1.0 - (y / xsect.rBot))))
  do return (((0.5 * xsect.rBot) * xsect.rBot) * ((theta1 - m_sin(theta1)))) end
end

-- xsect.c:2051
F.rect_round_getRofY = function(xsect, y)
  local theta1 = 0.0
  if (y <= 0.0) then
    do return 0.0 end
  end
  if (y > xsect.yBot) then
    do return F.rect_round_getRofA(xsect, F.rect_round_getAofY(xsect, y)) end
  end
  theta1 = (2.0 * m_acos((1.0 - (y / xsect.rBot))))
  do return (((0.5 * xsect.rBot) * ((1.0 - m_sin(theta1)))) / theta1) end
end

-- xsect.c:2065
F.rect_round_getWofY = function(xsect, y)
  if (y > xsect.yBot) then
    do return xsect.wMax end
  end
  do return (2.0 * m_sqrt((y * (((2.0 * xsect.rBot) - y))))) end
end

-- xsect.c:2082
F.mod_basket_getYofA = function(xsect, a)
  local alpha = 0.0
  local y1 = 0.0
  if (a <= (xsect.aFull - xsect.aBot)) then
    do return (a / xsect.wMax) end
  end
  alpha = (((xsect.aFull - a)) / (((3.141592654 * xsect.rBot) * xsect.rBot)))
  if (alpha < 0.04) then
    y1 = F.getYcircular(alpha)
  else
    y1 = F.lookup(alpha, G.Y_Circ, G.N_Y_Circ)
  end
  y1 = ((2.0 * xsect.rBot) * y1)
  do return (xsect.yFull - y1) end
end

-- xsect.c:2101
F.mod_basket_getRofA = function(xsect, a)
  local y1 = 0.0
  local p = 0.0
  local theta1 = 0.0
  if (a <= (xsect.aFull - xsect.aBot)) then
    do return (a / ((xsect.wMax + ((2.0 * a) / xsect.wMax)))) end
  end
  y1 = (xsect.yFull - F.mod_basket_getYofA(xsect, a))
  theta1 = (2.0 * m_acos((1.0 - (y1 / xsect.rBot))))
  p = (((xsect.sBot - theta1)) * xsect.rBot)
  y1 = (xsect.yFull - xsect.yBot)
  p = ((p + (2.0 * y1)) + xsect.wMax)
  do return (a / p) end
end

-- xsect.c:2128
F.mod_basket_getdSdA = function(xsect, a)
  local r = 0.0
  local dPdA = 0.0
  if ((a <= (xsect.aFull - xsect.aBot)) and ((a / xsect.aFull) > 1e-30)) then
    r = (a / ((xsect.wMax + ((2.0 * a) / xsect.wMax))))
    dPdA = (2.0 / xsect.wMax)
    do return ((((5.0 / 3.0) - ((((2.0 / 3.0)) * dPdA) * r))) * (r ^ (2.0 / 3.0))) end
  else
    do return F.generic_getdSdA(xsect, a) end
  end
end

-- xsect.c:2145
F.mod_basket_getAofY = function(xsect, y)
  local a1 = 0.0
  local theta1 = 0.0
  local y1 = 0.0
  if (y <= (xsect.yFull - xsect.yBot)) then
    do return (y * xsect.wMax) end
  end
  y1 = (xsect.yFull - y)
  theta1 = (2.0 * m_acos((1.0 - (y1 / xsect.rBot))))
  a1 = (((0.5 * xsect.rBot) * xsect.rBot) * ((theta1 - m_sin(theta1))))
  do return (xsect.aFull - a1) end
end

-- xsect.c:2162
F.mod_basket_getWofY = function(xsect, y)
  local y1 = 0.0
  if (y <= 0.0) then
    do return 0.0 end
  end
  if (y <= (xsect.yFull - xsect.yBot)) then
    do return xsect.wMax end
  end
  y1 = (xsect.yFull - y)
  do return (2.0 * m_sqrt((y1 * (((2.0 * xsect.rBot) - y1))))) end
end

-- xsect.c:2184
F.trapez_getYofA = function(xsect, a)
  if (xsect.sBot == 0.0) then
    do return (a / xsect.yBot) end
  end
  do return (((m_sqrt(((xsect.yBot * xsect.yBot) + ((4.0 * xsect.sBot) * a))) - xsect.yBot)) / ((2.0 * xsect.sBot))) end
end

-- xsect.c:2191
F.trapez_getRofA = function(xsect, a)
  do return (a / ((xsect.yBot + (F.trapez_getYofA(xsect, a) * xsect.rBot)))) end
end

-- xsect.c:2196
F.trapez_getdSdA = function(xsect, a)
  local r = 0.0
  local dPdA = 0.0
  if ((a / xsect.aFull) <= 1e-30) then
    do return F.generic_getdSdA(xsect, a) end
  end
  r = F.trapez_getRofA(xsect, a)
  dPdA = (xsect.rBot / m_sqrt(((xsect.yBot * xsect.yBot) + ((4.0 * xsect.sBot) * a))))
  do return ((((5.0 / 3.0) - ((((2.0 / 3.0)) * dPdA) * r))) * (r ^ (2.0 / 3.0))) end
end

-- xsect.c:2210
F.trapez_getAofY = function(xsect, y)
  do return (((xsect.yBot + (xsect.sBot * y))) * y) end
end

-- xsect.c:2215
F.trapez_getRofY = function(xsect, y)
  if (y == 0.0) then
    do return 0.0 end
  end
  do return (F.trapez_getAofY(xsect, y) / ((xsect.yBot + (y * xsect.rBot)))) end
end

-- xsect.c:2221
F.trapez_getWofY = function(xsect, y)
  do return (xsect.yBot + ((2.0 * y) * xsect.sBot)) end
end

-- xsect.c:2231
F.triang_getYofA = function(xsect, a)
  do return m_sqrt((a / xsect.sBot)) end
end

-- xsect.c:2236
F.triang_getRofA = function(xsect, a)
  do return (a / (((2.0 * F.triang_getYofA(xsect, a)) * xsect.rBot))) end
end

-- xsect.c:2241
F.triang_getdSdA = function(xsect, a)
  local r = 0.0
  local dPdA = 0.0
  if ((a / xsect.aFull) <= 1e-30) then
    do return F.generic_getdSdA(xsect, a) end
  end
  r = F.triang_getRofA(xsect, a)
  dPdA = (xsect.rBot / m_sqrt((a * xsect.sBot)))
  do return ((((5.0 / 3.0) - ((((2.0 / 3.0)) * dPdA) * r))) * (r ^ (2.0 / 3.0))) end
end

-- xsect.c:2253
F.triang_getAofY = function(xsect, y)
  do return ((y * y) * xsect.sBot) end
end

-- xsect.c:2258
F.triang_getRofY = function(xsect, y)
  do return (((y * xsect.sBot)) / ((2.0 * xsect.rBot))) end
end

-- xsect.c:2263
F.triang_getWofY = function(xsect, y)
  do return ((2.0 * xsect.sBot) * y) end
end

-- xsect.c:2273
F.parab_getYofA = function(xsect, a)
  do return (((((3.0 / 4.0)) * a) / xsect.rBot) ^ (2.0 / 3.0)) end
end

-- xsect.c:2278
F.parab_getRofA = function(xsect, a)
  if (a <= 0.0) then
    do return 0.0 end
  end
  do return (a / F.parab_getPofY(xsect, F.parab_getYofA(xsect, a))) end
end

-- xsect.c:2284
F.parab_getPofY = function(xsect, y)
  local x = ((2.0 * m_sqrt(y)) / xsect.rBot)
  local t = m_sqrt((1.0 + (x * x)))
  do return (((0.5 * xsect.rBot) * xsect.rBot) * (((x * t) + R.log((x + t))))) end
end

-- xsect.c:2291
F.parab_getAofY = function(xsect, y)
  do return (((((4.0 / 3.0) * xsect.rBot) * y) * m_sqrt(y))) end
end

-- xsect.c:2296
F.parab_getRofY = function(xsect, y)
  if (y <= 0.0) then
    do return 0.0 end
  end
  do return (F.parab_getAofY(xsect, y) / F.parab_getPofY(xsect, y)) end
end

-- xsect.c:2302
F.parab_getWofY = function(xsect, y)
  do return ((2.0 * xsect.rBot) * m_sqrt(y)) end
end

-- xsect.c:2312
F.powerfunc_getYofA = function(xsect, a)
  do return R.pow((a / xsect.rBot), (1.0 / ((xsect.sBot + 1.0)))) end
end

-- xsect.c:2317
F.powerfunc_getRofA = function(xsect, a)
  if (a <= 0.0) then
    do return 0.0 end
  end
  do return (a / F.powerfunc_getPofY(xsect, F.powerfunc_getYofA(xsect, a))) end
end

-- xsect.c:2323
F.powerfunc_getPofY = function(xsect, y)
  local dy1 = (0.02 * xsect.yFull)
  local h = ((((xsect.sBot + 1.0)) * xsect.rBot) / 2.0)
  local m = xsect.sBot
  local p = 0.0
  local y1 = 0.0
  local x1 = 0.0
  local x2 = 0.0
  local y2 = 0.0
  local dx = 0.0
  local dy = 0.0
  repeat
    do
      y2 = (y1 + dy1)
      if (y2 > y) then
        y2 = y
      end
      x2 = (h * R.pow(y2, m))
      dx = (x2 - x1)
      dy = (y2 - y1)
      p = (p + (m_sqrt(((dx * dx) + (dy * dy)))))
      x1 = x2
      y1 = y2
    end
  until not (y2 < y)
  do return (2.0 * p) end
end

-- xsect.c:2346
F.powerfunc_getAofY = function(xsect, y)
  do return (xsect.rBot * R.pow(y, (xsect.sBot + 1.0))) end
end

-- xsect.c:2351
F.powerfunc_getRofY = function(xsect, y)
  if (y <= 0.0) then
    do return 0.0 end
  end
  do return (F.powerfunc_getAofY(xsect, y) / F.powerfunc_getPofY(xsect, y)) end
end

-- xsect.c:2357
F.powerfunc_getWofY = function(xsect, y)
  do return ((((xsect.sBot + 1.0)) * xsect.rBot) * R.pow(y, xsect.sBot)) end
end

-- xsect.c:2367
F.circ_getYofA = function(xsect, a)
  local alpha = (a / xsect.aFull)
  if (alpha < 0.04) then
    do return (xsect.yFull * F.getYcircular(alpha)) end
  else
    do return (xsect.yFull * F.lookup(alpha, G.Y_Circ, G.N_Y_Circ)) end
  end
end

-- xsect.c:2378
F.circ_getAofS = function(xsect, s)
  local psi = (s / xsect.sFull)
  if (psi == 0.0) then
    do return 0.0 end
  end
  if (psi >= 1.0) then
    do return xsect.aFull end
  end
  if (psi <= 0.015) then
    do return (xsect.aFull * F.getAcircular(psi)) end
  else
    do return (xsect.aFull * F.invLookup(psi, G.S_Circ, G.N_S_Circ)) end
  end
end

-- xsect.c:2391
F.circ_getSofA = function(xsect, a)
  local alpha = (a / xsect.aFull)
  if (alpha < 0.04) then
    do return (xsect.sFull * F.getScircular(alpha)) end
  else
    do return (xsect.sFull * F.lookup(alpha, G.S_Circ, G.N_S_Circ)) end
  end
end

-- xsect.c:2403
F.circ_getdSdA = function(xsect, a)
  local alpha = 0.0
  local theta = 0.0
  local p = 0.0
  local r = 0.0
  local dPdA = 0.0
  alpha = (a / xsect.aFull)
  if (alpha <= 1e-30) then
    do return 1e-30 end
  elseif (alpha < 0.04) then
    theta = F.getThetaOfAlpha(alpha)
    p = ((theta * xsect.yFull) / 2.0)
    r = (a / p)
    dPdA = ((4.0 / xsect.yFull) / ((1.0 - m_cos(theta))))
    do return ((((5.0 / 3.0) - ((((2.0 / 3.0)) * dPdA) * r))) * (r ^ (2.0 / 3.0))) end
  else
    do return F.tabular_getdSdA(xsect, a, G.S_Circ, G.N_S_Circ) end
  end
end

-- xsect.c:2450
F.circ_getAofY = function(xsect, y)
  local yNorm = 0.0
  yNorm = (y / xsect.yFull)
  do return (xsect.aFull * F.lookup(yNorm, G.A_Circ, G.N_A_Circ)) end
end

-- xsect.c:2462
F.filled_circ_getYofA = function(xsect, a)
  local y = 0.0
  xsect.yFull = (xsect.yFull + xsect.yBot)
  xsect.aFull = (xsect.aFull + xsect.aBot)
  a = (a + xsect.aBot)
  y = F.circ_getYofA(xsect, a)
  y = (y - xsect.yBot)
  xsect.yFull = (xsect.yFull - xsect.yBot)
  xsect.aFull = (xsect.aFull - xsect.aBot)
  do return y end
end

-- xsect.c:2481
F.filled_circ_getAofY = function(xsect, y)
  local a = 0.0
  xsect.yFull = (xsect.yFull + xsect.yBot)
  xsect.aFull = (xsect.aFull + xsect.aBot)
  y = (y + xsect.yBot)
  a = F.circ_getAofY(xsect, y)
  a = (a - xsect.aBot)
  xsect.yFull = (xsect.yFull - xsect.yBot)
  xsect.aFull = (xsect.aFull - xsect.aBot)
  do return a end
end

-- xsect.c:2500
F.filled_circ_getRofY = function(xsect, y)
  local a = 0.0
  local r = 0.0
  local p = 0.0
  xsect.yFull = (xsect.yFull + xsect.yBot)
  xsect.aFull = (xsect.aFull + xsect.aBot)
  y = (y + xsect.yBot)
  a = F.circ_getAofY(xsect, y)
  r = ((0.25 * xsect.yFull) * F.lookup((y / xsect.yFull), G.R_Circ, G.N_R_Circ))
  p = ((a / r))
  a = (a - xsect.aBot)
  p = ((p - xsect.rBot) + xsect.sBot)
  r = (a / p)
  xsect.yFull = (xsect.yFull - xsect.yBot)
  xsect.aFull = (xsect.aFull - xsect.aBot)
  do return r end
end

-- xsect.c:2531
F.getYcircular = function(alpha)
  local theta = 0.0
  if (alpha >= 1.0) then
    do return 1.0 end
  end
  if (alpha <= 0.0) then
    do return 0.0 end
  end
  if (alpha <= 1e-05) then
    theta = ((37.6911 * alpha) ^ (1.0 / 3.0))
    do return ((theta * theta) / 16.0) end
  end
  theta = F.getThetaOfAlpha(alpha)
  do return (((1.0 - m_cos((theta / 2.0)))) / 2.0) end
end

-- xsect.c:2545
F.getScircular = function(alpha)
  local theta = 0.0
  if (alpha >= 1.0) then
    do return 1.0 end
  end
  if (alpha <= 0.0) then
    do return 0.0 end
  end
  if (alpha <= 1e-05) then
    theta = ((37.6911 * alpha) ^ (1.0 / 3.0))
    do return ((theta ^ (13.0 / 3.0)) / 124.4797) end
  end
  theta = F.getThetaOfAlpha(alpha)
  do return (((((theta - m_sin(theta))) ^ (5.0 / 3.0)) / ((2.0 * 3.141592654))) / (theta ^ (2.0 / 3.0))) end
end

-- xsect.c:2559
F.getAcircular = function(psi)
  local theta = 0.0
  if (psi >= 1.0) then
    do return 1.0 end
  end
  if (psi <= 0.0) then
    do return 0.0 end
  end
  if (psi <= 1e-06) then
    theta = ((124.4797 * psi) ^ (3.0 / 13.0))
    do return (((theta * theta) * theta) / 37.6911) end
  end
  theta = F.getThetaOfPsi(psi)
  do return (((theta - m_sin(theta))) / ((2.0 * 3.141592654))) end
end

-- xsect.c:2573
F.getThetaOfAlpha = function(alpha)
  local k = 0
  local theta = 0.0
  local theta1 = 0.0
  local ap = 0.0
  local d = 0.0
  if (alpha > 0.04) then
    theta = (1.2 + ((5.08 * ((alpha - 0.04))) / 0.96))
  else
    theta = ((0.031715 - (12.79384 * alpha)) + (8.28479 * m_sqrt(alpha)))
  end
  theta1 = theta
  ap = (((2.0 * 3.141592654)) * alpha)
  do
    k = 1
    while (k <= 40) do
      do
        d = ((-(((ap - theta) + m_sin(theta)))) / ((1.0 - m_cos(theta))))
        if (d > 1.0) then
          d = ((((d) >= 0.0) and m_abs(1.0) or (-(m_abs(1.0)))))
        end
        theta = (theta - d)
        if (m_abs(d) <= 0.0001) then
          do return theta end
        end
      end
      k = k + 1
    end
  end
  do return theta1 end
end

-- xsect.c:2593
F.getThetaOfPsi = function(psi)
  local k = 0
  local theta = 0.0
  local theta1 = 0.0
  local ap = 0.0
  local tt = 0.0
  local tt23 = 0.0
  local t3 = 0.0
  local d = 0.0
  if (psi > 0.9) then
    theta = (4.17 + ((1.12 * ((psi - 0.9))) / 0.176))
  elseif (psi > 0.5) then
    theta = (3.14 + ((1.03 * ((psi - 0.5))) / 0.4))
  elseif (psi > 0.015) then
    theta = (1.2 + ((1.94 * ((psi - 0.015))) / 0.485))
  else
    theta = ((0.12103 - (55.5075 * psi)) + (15.62254 * m_sqrt(psi)))
  end
  theta1 = theta
  ap = (((2.0 * 3.141592654)) * psi)
  do
    k = 1
    while (k <= 40) do
      do
        theta = m_abs(theta)
        tt = (theta - m_sin(theta))
        tt23 = (tt ^ (2.0 / 3.0))
        t3 = (theta ^ (1.0 / 3.0))
        d = (((ap * theta) / t3) - (tt * tt23))
        d = (d / ((((ap * ((2.0 / 3.0))) / t3) - ((((5.0 / 3.0)) * tt23) * ((1.0 - m_cos(theta)))))))
        theta = (theta - d)
        if (m_abs(d) <= 0.0001) then
          do return theta end
        end
      end
      k = k + 1
    end
  end
  do return theta1 end
end

