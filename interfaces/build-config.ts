export interface BuildConfig {
    environment:    string;
    app:            string;
    name:           string;
    Tags:           Tags;
    havaAwsAccount: string;
    havaExternalId: string;
}

export interface Tags {
    contact:  string;
    owner:    string;
    repo:     string;
    costCode: string;
    repoUrl:  string;
}
