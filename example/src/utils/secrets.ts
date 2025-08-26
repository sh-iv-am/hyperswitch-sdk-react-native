import { Platform } from "react-native";

const getSecrets = async (): Promise<{
    clientSecret?: string;
    publishableKey?: string;
    error?: string | null;
}> => {
    try {
        const url = Platform.OS === "ios"
            ? 'http://localhost:5252'
            : 'http://10.0.2.2:5252'

        const response = await fetch(
            `${url}/create-payment-intent`
        )

        const data = await response.json();

        if (response.ok) {
            return { clientSecret: data.clientSecret, publishableKey: data.publishableKey };
        }
        return { error: data.error || "Failed to retrieve secrets" };

    } catch (error) {
        console.error("Error fetching secrets:", error);
        return { error: "Failed to load client secret" };
    }

};

export default getSecrets;