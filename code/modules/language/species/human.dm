/datum/language/human
	id = LANGUAGE_ID_HUMAN
	name = LANGUAGE_SOL_COMMON
	desc = "A bastardized hybrid of many languages, including Chinese, English, French, and more; it is the common language of the Sol system."
	speech_verb = "says"
	whisper_verb = "whispers"
	exclaim_verb = list("exclaims","shouts","yells")
	colour = "solcom"
	key = "1"
	//syllables are at the bottom of the file

/datum/language/human/get_random_name(gender)
	if (prob(80))
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	else
		return ..()

/datum/language/slavic
	id = LANGUAGE_ID_HUMAN_SLAVIC
	name = LANGUAGE_SLAVIC
	desc = "Was established in 2122 by the short-lived United Slavic Confederation on Earth."
	colour = "solcom"
	key = "G"
	syllables = list(
		"rus", "zem", "ave", "groz", "ski", "ska", "ven", "konst", "pol", "lin", "svy",
		"danya", "da", "mied", "zan", "das", "krem", "myka", "to", "st", "no", "na", "ni",
		"ko", "ne", "en", "po", "ra", "li", "on", "byl", "cto", "eni", "ost", "ol", "ego",
		"ver", "stv", "pro"
	)

//Syllable Lists
/*
	This list really long, mainly because I can't make up my mind about which mandarin syllables should be removed,
	and the english syllables had to be duplicated so that there is roughly a 50-50 weighting.
	The other 3 languages were duplicated just so they could show occasionally.

	Sources:
	http://www.sttmedia.com/syllablefrequency-english
	http://www.sttmedia.com/syllablefrequency-spanish
	http://www.sttmedia.com/syllablefrequency-russian
	http://www.sttmedia.com/syllablefrequency-french
	http://www.chinahighlights.com/travelguide/learning-chinese/pinyin-syllables.htm
*/
/datum/language/human/syllables = list(
"a", "ai", "an", "ang", "ao", "ba", "bai", "ban", "bang", "bao", "bei", "ben", "beng", "bi", "bian", "biao",
"bie", "bin", "bing", "bo", "bu", "ca", "cai", "can", "cang", "cao", "ce", "cei", "cen", "ceng", "cha", "chai",
"chan", "chang", "chao", "che", "chen", "cheng", "chi", "chong", "chou", "chu", "chua", "chuai", "chuan", "chuang", "chui", "chun",
"chuo", "ci", "cong", "cou", "cu", "cuan", "cui", "cun", "cuo", "da", "dai", "dan", "dang", "dao", "de", "dei",
"den", "deng", "di", "dian", "diao", "die", "ding", "diu", "dong", "dou", "du", "duan", "dui", "dun", "duo", "e",
"ei", "en", "er", "fa", "fan", "fang", "fei", "fen", "feng", "fo", "fou", "fu", "ga", "gai", "gan", "gang",
"gao", "ge", "gei", "gen", "geng", "gong", "gou", "gu", "gua", "guai", "guan", "guang", "gui", "gun", "guo", "ha",
"hai", "han", "hang", "hao", "he", "hei", "hen", "heng", "hm", "hng", "hong", "hou", "hu", "hua", "huai", "huan",
"huang", "hui", "hun", "huo", "ji", "jia", "jian", "jiang", "jiao", "jie", "jin", "jing", "jiong", "jiu", "ju", "juan",
"jue", "jun", "ka", "kai", "kan", "kang", "kao", "ke", "kei", "ken", "keng", "kong", "kou", "ku", "kua", "kuai",
"kuan", "kuang", "kui", "kun", "kuo", "la", "lai", "lan", "lang", "lao", "le", "lei", "leng", "li", "lia", "lian",
"liang", "liao", "lie", "lin", "ling", "liu", "long", "lou", "lu", "luan", "lun", "luo", "ma", "mai", "man", "mang",
"mao", "me", "mei", "men", "meng", "mi", "mian", "miao", "mie", "min", "ming", "miu", "mo", "mou", "mu", "na",
"nai", "nan", "nang", "nao", "ne", "nei", "nen", "neng", "ng", "ni", "nian", "niang", "niao", "nie", "nin", "ning",
"niu", "nong", "nou", "nu", "nuan", "nuo", "o", "ou", "pa", "pai", "pan", "pang", "pao", "pei", "pen", "peng",
"pi", "pian", "piao", "pie", "pin", "ping", "po", "pou", "pu", "qi", "qia", "qian", "qiang", "qiao", "qie", "qin",
"qing", "qiong", "qiu", "qu", "quan", "que", "qun", "ran", "rang", "rao", "re", "ren", "reng", "ri", "rong", "rou",
"ru", "rua", "ruan", "rui", "run", "ruo", "sa", "sai", "san", "sang", "sao", "se", "sei", "sen", "seng", "sha",
"shai", "shan", "shang", "shao", "she", "shei", "shen", "sheng", "shi", "shou", "shu", "shua", "shuai", "shuan", "shuang", "shui",
"shun", "shuo", "si", "song", "sou", "su", "suan", "sui", "sun", "suo", "ta", "tai", "tan", "tang", "tao", "te",
"teng", "ti", "tian", "tiao", "tie", "ting", "tong", "tou", "tu", "tuan", "tui", "tun", "tuo", "wa", "wai", "wan",
"wang", "wei", "wen", "weng", "wo", "wu", "xi", "xia", "xian", "xiang", "xiao", "xie", "xin", "xing", "xiong", "xiu",
"xu", "xuan", "xue", "xun", "ya", "yan", "yang", "yao", "ye", "yi", "yin", "ying", "yong", "you", "yu", "yuan",
"yue", "yun", "za", "zai", "zan", "zang", "zao", "ze", "zei", "zen", "zeng", "zha", "zhai", "zhan", "zhang", "zhao",
"zhe", "zhei", "zhen", "zheng", "zhi", "zhong", "zhou", "zhu", "zhua", "zhuai", "zhuan", "zhuang", "zhui", "zhun", "zhuo", "zi",
"zong", "zou", "zuan", "zui", "zun", "zuo", "zu",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
"le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to",
"ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin",
"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi",
"ah", "be", "bo", "eh", "ep", "et", "ka", "ko", "ha", "he", "ho", "ob", "oh", "op", "oc", "ot", "pa", "pe", "ct", "ta", "te", "to",
"vse", "tak", "nak", "no", "epo", "pre", "kan", "dly", "ime", "sha", "kur", "yey", "khi", "yeg", "ne",
"ion", "ne", "nas", "v",
"ah", "be", "bo", "eh", "ep", "et", "ka", "ko", "ha", "he", "ho", "ob", "oh", "op", "oc", "ot", "pa", "pe", "ct", "ta", "te", "to",
"vse", "tak", "nak", "no", "epo", "pre", "kan", "dly", "ime", "sha", "kur", "yey", "khi", "yeg", "ne",
"ion", "ne", "nas", "v",
"ah", "be", "bo", "eh", "ep", "et", "ka", "ko", "ha", "he", "ho", "ob", "oh", "op", "oc", "ot", "pa", "pe", "ct", "ta", "te", "to",
"vse", "tak", "nak", "no", "epo", "pre", "kan", "dly", "ime", "sha", "kur", "yey", "khi", "yeg", "ne",
"ion", "ne", "nas", "v",
"ai", "an", "ar", "au", "ce", "ch", "co", "de", "em", "en", "er", "es", "et", "eu", "il", "in", "is", "la", "le",
"ma", "me", "ne", "ns", "nt", "on", "ou", "pa", "qu", "ra", "re", "se", "te", "ti", "tr", "ue", "ur", "us", "ve",
"tou", "e", "eve", "hen", "son", "non", "not", "le",
"ai", "an", "ar", "au", "ce", "ch", "co", "de", "em", "en", "er", "es", "et", "eu", "il", "in", "is", "la", "le",
"ma", "me", "ne", "ns", "nt", "on", "ou", "pa", "qu", "ra", "re", "se", "te", "ti", "tr", "ue", "ur", "us", "ve",
"tou", "e", "eve", "hen", "son", "non", "not", "le",
"ai", "an", "ar", "au", "ce", "ch", "co", "de", "em", "en", "er", "es", "et", "eu", "il", "in", "is", "la", "le",
"ma", "me", "ne", "ns", "nt", "on", "ou", "pa", "qu", "ra", "re", "se", "te", "ti", "tr", "ue", "ur", "us", "ve",
"tou", "e", "eve", "hen", "son", "non", "not", "le",
"ad", "al", "an", "ar", "as", "ci", "co", "de", "do", "el", "en", "er", "es", "ie", "in", "la", "lo", "me", "na",
"no", "nt", "or", "os", "pa", "qu", "ra", "re", "ro", "se", "st", "ta", "te", "to", "ue", "un",
"tod", "ser", "su", "no", "nue", "el",
"ad", "al", "an", "ar", "as", "ci", "co", "de", "do", "el", "en", "er", "es", "ie", "in", "la", "lo", "me", "na",
"no", "nt", "or", "os", "pa", "qu", "ra", "re", "ro", "se", "st", "ta", "te", "to", "ue", "un",
"tod", "ser", "su", "no", "nue", "el",
"ad", "al", "an", "ar", "as", "ci", "co", "de", "do", "el", "en", "er", "es", "ie", "in", "la", "lo", "me", "na",
"no", "nt", "or", "os", "pa", "qu", "ra", "re", "ro", "se", "st", "ta", "te", "to", "ue", "un",
"tod", "ser", "su", "no", "nue", "el")
