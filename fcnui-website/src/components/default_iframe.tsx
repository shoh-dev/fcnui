type Props = {
    src: string,
}

export default function DefaultIframe(props: Props) {
    return (
        <iframe src={props.src} width="100%" height="300px" />
    );
}