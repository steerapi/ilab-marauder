--This is only an example and dont necessarily fully represent a british keyboard
function keyLang(self)
	return
		{	
			{--Lower Case
				{ {"q", {"1","Q"}}, {"w", {"2","W"}}, {"e", {"3","E","è","é","ê","ë"}}, {"r", {"4","R"}}, {"t", {"5","T"}}, {"y", {"6","Y","ý","ÿ"}}, {"u", {"7","U","ù","ú","û","ü"}}, {"i",{"8","I","í","î","ï"}}, {"o",{"9","O","ò","ó","ô","õ","ö", "œ","ø"}}, {"p", {"0","P"}} },
				{ self.EXTRASPACE, {"a",{"A","à","á","â","ã","ä","å","æ"}}, {"s", {"S","§","ß"}}, {"d", {"D"}}, {"f", {"F"}}, {"g", {"G"}}, {"h", {"H"}}, {"j", {"J"}}, {"k", {"K"}}, {"l", {"L"}} },
				{ self.UPPER, {"z", {"Z"}}, {"x", {"X"}}, {"c", {"C","ç"}}, {"v", {"V"}}, {"b", {"B"}}, {"n", {"N","ñ"}}, {"m", {"M"}}, self.DEL },
				{ self.NUMBERS, self.EXTRASPACE,self.EXTRASPACE,self.SPACE, ".", self.HIDE }
			} ,	
			{--Upper Case
				{ {"Q",{"1"}}, {"W",{"2"}}, {"E",{"3","È","É","Ê","Ë"}}, {"R",{"4"}}, {"T",{"5"}}, {"Y",{"6","Ý","Ÿ"}}, {"U",{"7","Ù","Ú","Û","Ü"}}, {"I",{"8","Í","Î","Ï"}}, {"O",{"9","Ò","Ó","Ô","Õ","Ö","Œ","Ø"}}, {"P",{"0"}}},
				{ self.EXTRASPACE, {"A",{"À","Á","Â","Ã","Ä","Å","Æ"}}, {"S",{"§","ß"}}, "D", "F", "G", "H", "J", "K", "L" },
				{ self.LOWER, "Z", "X", {"C",{"Ç"}}, "V", "B", {"N",{"Ñ"}}, "M", self.DEL },
				{ self.NUMBERS,  self.EXTRASPACE,self.EXTRASPACE,self.SPACE, ".", self.HIDE }	
			} ,	
			{--Numerical and other
				{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", },
				{  "@", "#", "%", "&", "*", "/", "-", "+", "(", ")" },
				{ self.EXTRASPACE,self.EXTRASPACE, "?", "!", "\"", "'", ":", ";", ",", self.DEL },
				{ self.TEXT, self.EXTRASPACE,self.EXTRASPACE, self.SPACE, ".", self.HIDE   }	
			}
		}
end