<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Teams_api
{
    public $CI;
    private $tenant_id;
    private $client_id;
    private $client_secret;
    private $access_token;
    private $graph_url = 'https://graph.microsoft.com/v1.0';
    private $token_url = 'https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token';

    public function __construct($parameters = array())
    {
        $this->CI = &get_instance();

        if (!empty($parameters)) {
            $this->tenant_id = isset($parameters['tenant_id']) ? $parameters['tenant_id'] : '';
            $this->client_id = isset($parameters['client_id']) ? $parameters['client_id'] : '';
            $this->client_secret = isset($parameters['client_secret']) ? $parameters['client_secret'] : '';
        }
    }

    /**
     * Get OAuth2 access token using client credentials flow
     * @return array
     */
    public function getAccessToken()
    {
        $url = str_replace('{tenant}', $this->tenant_id, $this->token_url);

        $post_data = array(
            'client_id' => $this->client_id,
            'client_secret' => $this->client_secret,
            'scope' => 'https://graph.microsoft.com/.default',
            'grant_type' => 'client_credentials',
        );

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post_data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);

        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        $result = json_decode($response, true);

        if ($http_code == 200 && isset($result['access_token'])) {
            $this->access_token = $result['access_token'];
            return array('status' => true, 'token' => $result['access_token']);
        }

        $error_msg = isset($result['error_description']) ? $result['error_description'] : 'Failed to get access token';
        return array('status' => false, 'message' => $error_msg);
    }

    /**
     * Create an online meeting
     * @param array $meeting_data
     * @return array
     */
    public function createMeeting($meeting_data)
    {
        if (empty($this->access_token)) {
            $token_result = $this->getAccessToken();
            if (!$token_result['status']) {
                return $token_result;
            }
        }

        $organizer_id = isset($meeting_data['organizer_id']) ? $meeting_data['organizer_id'] : '';
        if (empty($organizer_id)) {
            return array('status' => false, 'message' => 'Organizer user ID is required');
        }

        $start_time = date('Y-m-d\TH:i:s', strtotime($meeting_data['date']));
        $end_time = date('Y-m-d\TH:i:s', strtotime($meeting_data['date'] . ' +' . $meeting_data['duration'] . ' minutes'));
        $timezone = isset($meeting_data['timezone']) ? $meeting_data['timezone'] : 'UTC';

        $request_body = array(
            'subject' => $meeting_data['title'],
            'startDateTime' => $start_time,
            'endDateTime' => $end_time,
            'lobbyBypassSettings' => array(
                'scope' => 'everyone',
                'isDialInBypassEnabled' => true,
            ),
        );

        $url = $this->graph_url . '/users/' . $organizer_id . '/onlineMeetings';

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($request_body));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Authorization: Bearer ' . $this->access_token,
            'Content-Type: application/json',
        ));

        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        $result = json_decode($response, true);

        if ($http_code == 201 || $http_code == 200) {
            return array(
                'status' => true,
                'data' => array(
                    'id' => $result['id'],
                    'join_url' => $result['joinWebUrl'],
                    'subject' => $result['subject'],
                    'start_time' => $result['startDateTime'],
                    'end_time' => $result['endDateTime'],
                ),
            );
        }

        $error_msg = isset($result['error']['message']) ? $result['error']['message'] : 'Failed to create meeting';
        return array('status' => false, 'message' => $error_msg);
    }

    /**
     * Delete an online meeting
     * @param string $organizer_id
     * @param string $meeting_id
     * @return array
     */
    public function deleteMeeting($organizer_id, $meeting_id)
    {
        if (empty($this->access_token)) {
            $token_result = $this->getAccessToken();
            if (!$token_result['status']) {
                return $token_result;
            }
        }

        $url = $this->graph_url . '/users/' . $organizer_id . '/onlineMeetings/' . $meeting_id;

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Authorization: Bearer ' . $this->access_token,
            'Content-Type: application/json',
        ));

        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($http_code == 204 || $http_code == 200) {
            return array('status' => true);
        }

        $result = json_decode($response, true);
        $error_msg = isset($result['error']['message']) ? $result['error']['message'] : 'Failed to delete meeting';
        return array('status' => false, 'message' => $error_msg);
    }

    /**
     * Check if Teams API credentials are configured
     * @return bool
     */
    public function isConfigured()
    {
        return !empty($this->tenant_id) && !empty($this->client_id) && !empty($this->client_secret);
    }
}
