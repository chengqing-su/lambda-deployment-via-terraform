import {
    CloudWatchLogsEvent
} from "aws-lambda";
export const handler = async (
    event: CloudWatchLogsEvent
): Promise<void> => {
    console.log(event)
    console.log("This is test lambda")
}