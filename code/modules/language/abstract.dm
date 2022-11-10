// Noise "language", for audible emotes.
/datum/language/noise
	id = LANGUAGE_ID_NOISE
	name = "Noise"
	desc = "Noises"
	key = ""
	language_flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG|NO_STUTTER

/datum/language/noise/format_message(message, verb)
	return "<span class='message'><span class='[colour]'>[message]</span></span>"

/datum/language/noise/format_message_plain(message, verb)
	return message

/datum/language/noise/format_message_radio(message, verb)
	return "<span class='[colour]'>[message]</span>"

/datum/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2

/datum/language/noise/can_speak_special(var/mob/speaker)
	return TRUE	//Audible emotes

// Silly language for those times when you try to talk a languague you normally can't
/datum/language/gibberish
	id = LANGUAGE_ID_GIBBERISH
	name = LANGUAGE_GIBBERISH
	desc = "A completely incomprehensible language."
	signlang_verb = list("flails")
	speech_verb = "spews"
	whisper_verb = "mumbles"
	exclaim_verb = "shrieks"
	colour = "attack"
	key = "r"	// Radda radda radda
	language_flags = RESTRICTED|NONGLOBAL
	machine_understands = 0
	syllables = list (
			"radda", "fea","vea","vei","veh","vee","feh","fa","soa","su","sua","sou","se","seh","twa","twe","twi",
			"ahm","lea","lee","nae","nah","pa","pau","fae","fai","soh","mou","ahe","ll","ea","ai","thi",
			"hie","zei","zie","ize","ehy","uy","oya","dor","di","ja","ej","er","um","in","qu","is","re",
			"nt","ti","us","it","en","at","tu","te","ri","es","et","ra","ta","an","ni","li","on","or","se",
			"am","ae","ia","di","ue","em","ar","ui","st","si","de","ci","iu","ne","pe","co","os","ur","ru",
			"gra","ba","ba","breh","bra","rah","dur","ra","ro","gro","go","ber","bar","geh","heh", "gra",
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
			"zong", "zou", "zuan", "zui", "zun", "zuo", "zu", "al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it",
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
			"his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi"
			)

/datum/language/gibberish/can_speak_special(var/mob/speaker)
	return TRUE	//Anyone can speak gibberish
