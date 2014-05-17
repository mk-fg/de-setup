#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include <sensors/error.h>
#include <sensors/sensors.h>


#define SENS_BIN "sens"

void usage(FILE *stream, int eval) {
	fprintf(stream, "Usage: %s [-h] [--help] [--] [config]\n", SENS_BIN);
	exit(eval);
}


int main(int argc, char **argv) {
	// CLI
	int c;

	while ((c = getopt(argc, argv, "h-")) != -1) {
		switch (c) {
			case '-':
				if (strcmp(argv[optind], "--help") != 0) {
					fprintf(stderr, "%s: invalid option -- '%s'\n", SENS_BIN, argv[optind]);
					usage(stderr, 1);
				}
			case 'h':
				usage(stdout, 0);
			default:
				usage(stderr, 1);
		}
	}

	int conf_arg = argc - optind;
	if (conf_arg > 1) usage(stderr, 1);


	// Init
	int exit_code = 0;
	FILE *conf_file = NULL;

	if (conf_arg > 0) conf_file = fopen(argv[optind], "r");
	if (sensors_init(conf_file) != 0) {
		fprintf(stderr, "libsensors init failed\n");
		exit(1);
	}


	// Read
	const sensors_chip_name *scn;
	const sensors_feature *sf;
	const sensors_subfeature *ss;
	int n, n1, n2, err;
	double r;
	char scns[80];

	for(n = 0; (scn = sensors_get_detected_chips(NULL, &n)) != NULL; ) {
		sprintf(scns, "%s-%x-%x", scn->prefix, scn->bus.nr, scn->addr);
		/* printf("- %s\n", scns); */

		for(n1 = 0; (sf = sensors_get_features(scn, &n1)) != NULL; )
			for(n2 = 0; (ss = sensors_get_all_subfeatures(scn, sf, &n2)) != NULL; ) {
				err = sensors_get_value(scn, ss->number, &r);
				if (err == 0) printf("%s__%s %f\n", scns, ss->name, r);
				else {
					fprintf( stderr,
						"Error reading value for %s/%s: %s\n",
						scns, ss->name, sensors_strerror(err) );
					exit_code = 1;
				}
			}
	}


	// Cleanup
	sensors_cleanup();
	exit(exit_code);
}
