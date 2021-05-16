package gglargs

// https://github.com/mfvalin/dot-profile-setup/blob/master/src/cclargs_lite%2B.c

//struct definition
//{
//    char *kle_nom;        /* nom de la clef */
//    char *kle_def1;       /* premiere valeur de defaut */
//    char *kle_def2;       /* deuxieme valeur de defaut */
//    char *kle_val;        /* valeur finale donnee a la clef */
//    char *kle_desc;       /* descripteur pour aide interactive */
//    enum typecle type;
//};

type Definition struct {
	KeyName             string
	KeyDefault          string
	KeyAlternateDefault string
	KeyDescription      string
	KeyType             int

	Value string
}
